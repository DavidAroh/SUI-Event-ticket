module eventticket::event_ticket {
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::ascii::String;

    // Event structure for ticket operations
    public struct TicketIssued has copy, drop {
        ticket_id: u64,
        event_title: String,
        seat: u64,
        holder: address,
    }

    // Alternative event structure with different naming
    public struct EventTicketCreated has copy, drop {
        name: String,
        seat_num: u64,
        ticket_holder: address,
    }

    // Event for ticket transfers
    public struct TicketTransferred has copy, drop {
        ticket_id: u64,
        event_title: String,
        seat: u64,
        from_address: address,
        to_address: address,
    }

    // Main ticket object that can be owned and transferred
    public struct EventTicket has key, store {
        id: UID,
        ticket_id: u64,
        event_title: String,
        seat: u64,
        original_issuer: address,
    }

    // Primary function to emit ticket events
    public fun publish_ticket_issued(
        ticket_id: u64,
        event_title: String,
        seat: u64,
        holder: address
    ) {
        event::emit(TicketIssued {
            ticket_id,
            event_title,
            seat,
            holder,
        });
    }

    // Alternative function with different parameter names
    public fun create_event_ticket(
        name: String,
        seat_num: u64,
        ticket_holder: address
    ) {
        event::emit(EventTicketCreated {
            name,
            seat_num,
            ticket_holder,
        });
    }

    // Legacy compatibility function that matches original functionality
    public fun emit_ticket_event(
        event_name: String,
        seat_number: u64,
        owner: address
    ) {
        publish_ticket_issued(0, event_name, seat_number, owner);
    }

    // Create a new ticket object that can be owned and transferred
    public fun create_ticket(
        ticket_id: u64,
        event_title: String,
        seat: u64,
        recipient: address,
        ctx: &mut TxContext
    ): EventTicket {
        let ticket = EventTicket {
            id: object::new(ctx),
            ticket_id,
            event_title,
            seat,
            original_issuer: tx_context::sender(ctx),
        };
        
        // Emit ticket creation event
        publish_ticket_issued(ticket_id, event_title, seat, recipient);
        
        ticket
    }

    // Transfer ticket to a new owner
    public fun transfer_ticket(
        ticket: EventTicket,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let from_address = tx_context::sender(ctx);
        let ticket_id = ticket.ticket_id;
        let event_title = ticket.event_title;
        let seat = ticket.seat;
        
        // Emit transfer event
        event::emit(TicketTransferred {
            ticket_id,
            event_title,
            seat,
            from_address,
            to_address: recipient,
        });
        
        // Transfer the ticket object
        transfer::public_transfer(ticket, recipient);
    }

    // Get ticket details (read-only)
    public fun get_ticket_info(ticket: &EventTicket): (u64, String, u64, address) {
        (
            ticket.ticket_id,
            ticket.event_title,
            ticket.seat,
            ticket.original_issuer
        )
    }

    // Update ticket seat number (only original issuer can do this)
    public fun update_seat(
        ticket: &mut EventTicket,
        new_seat: u64,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == ticket.original_issuer, 1);
        ticket.seat = new_seat;
    }
}
