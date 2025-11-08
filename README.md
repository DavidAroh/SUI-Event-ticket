# SUI Event Ticket System

A Move smart contract module for managing event tickets on the SUI blockchain. This module provides event emission capabilities for tracking ticket creation and ownership.

## Overview

This module implements an event ticket management system that allows developers to emit events when tickets are created, issued, or transferred. The system provides multiple event structures and functions to accommodate different use cases while maintaining backward compatibility.

## Features

- **Transferable Tickets**: Real ticket objects that can be owned and transferred
- **Transfer Events**: Complete audit trail of ticket ownership changes
- **Multiple Event Types**: Support for different ticket event structures
- **Backward Compatibility**: Maintains original function signatures
- **Enhanced Functionality**: Additional fields and improved parameter naming
- **Type Safety**: Strong typing with Move's resource model
- **Access Control**: Authorization checks for sensitive operations

## Module Structure

### Event Structures

#### `TicketIssued`
Enhanced event structure with additional ticket identification:
```move
public struct TicketIssued has copy, drop {
    ticket_id: u64,
    event_title: String,
    seat: u64,
    holder: address,
}
```

#### `EventTicketCreated`
Alternative event structure with simplified naming:
```move
public struct EventTicketCreated has copy, drop {
    name: String,
    seat_num: u64,
    ticket_holder: address,
}
```

#### `TicketTransferred`
Event emitted when tickets are transferred between addresses:
```move
public struct TicketTransferred has copy, drop {
    ticket_id: u64,
    event_title: String,
    seat: u64,
    from_address: address,
    to_address: address,
}
```

#### `EventTicket`
Main ticket object that can be owned and transferred:
```move
public struct EventTicket has key, store {
    id: UID,
    ticket_id: u64,
    event_title: String,
    seat: u64,
    original_issuer: address,
}
```

### Functions

#### `publish_ticket_issued(ticket_id: u64, event_title: String, seat: u64, holder: address)`
Emits a `TicketIssued` event with full ticket details including a unique ticket ID.

#### `create_event_ticket(name: String, seat_num: u64, ticket_holder: address)`
Emits an `EventTicketCreated` event with simplified parameter naming.

#### `emit_ticket_event(event_name: String, seat_number: u64, owner: address)`
Legacy compatibility function that maintains the original interface while using the enhanced implementation internally.

#### `create_ticket(ticket_id: u64, event_title: String, seat: u64, recipient: address, ctx: &mut TxContext): EventTicket`
Creates a new ticket object that can be owned and transferred. Returns the created ticket object.

#### `transfer_ticket(ticket: EventTicket, recipient: address, ctx: &mut TxContext)`
Transfers ticket ownership to a new recipient and emits a transfer event.

#### `get_ticket_info(ticket: &EventTicket): (u64, String, u64, address)`
Read-only function to query ticket details (ticket ID, event title, seat, original issuer).

#### `update_seat(ticket: &mut EventTicket, new_seat: u64, ctx: &mut TxContext)`
Updates the seat number of a ticket. Only the original issuer can perform this operation.

## Usage Examples

### Basic Ticket Creation
```move
// Using the enhanced function with ticket ID
publish_ticket_issued(
    12345,                                    // ticket_id
    ascii::string(b"Concert 2024"),          // event_title
    42,                                       // seat
    @0x1234567890abcdef1234567890abcdef     // holder
);
```

### Alternative Event Emission
```move
// Using the alternative function
create_event_ticket(
    ascii::string(b"Theater Show"),          // name
    15,                                       // seat_num
    @0xabcdef1234567890abcdef1234567890     // ticket_holder
);
```

### Legacy Compatibility
```move
// Using the original function signature
emit_ticket_event(
    ascii::string(b"Sports Game"),          // event_name
    7,                                        // seat_number
    @0xfedcba0987654321fedcba0987654321      // owner
);
```

### Ticket Creation and Transfer
```move
// Create a new ticket object
let ticket = create_ticket(
    12345,                                    // ticket_id
    ascii::string(b"Concert 2024"),          // event_title
    42,                                       // seat
    @0x1234567890abcdef1234567890abcdef,    // recipient
    ctx                                       // transaction context
);

// Transfer ticket to new owner
transfer_ticket(
    ticket,                                   // ticket object
    @0xabcdef1234567890abcdef1234567890,    // new recipient
    ctx                                       // transaction context
);

// Get ticket information
let (ticket_id, event_title, seat, issuer) = get_ticket_info(&ticket);

// Update seat number (only original issuer)
update_seat(&mut ticket, 50, ctx);         // new_seat: 50
```

## Dependencies

- `sui::event` - For event emission functionality
- `sui::object` - For object management and UID generation
- `sui::transfer` - For transferring objects between addresses
- `sui::tx_context` - For transaction context and sender information
- `std::ascii::String` - For string handling

## Building and Testing

To build the module:
```bash
sui move build
```

To run tests:
```bash
sui move test
```

## Architecture Benefits

1. **True Asset Ownership**: Tickets are real objects that can be owned, transferred, and managed
2. **Complete Audit Trail**: Every transfer is recorded with detailed event information
3. **Access Control**: Authorization ensures only authorized parties can modify tickets
4. **Flexibility**: Multiple event structures allow for different use cases
5. **Extensibility**: Easy to add new event types and functions
6. **Compatibility**: Maintains existing function signatures for backward compatibility
7. **Clarity**: Improved parameter naming and documentation
8. **Type Safety**: Leverages Move's strong type system for secure event handling

## Future Enhancements

Potential improvements that could be added:
- Batch ticket operations for creating multiple tickets at once
- Event validation and verification mechanisms
- Integration with payment systems for ticket purchases
- Multi-signature ticket management for enterprise use
- Ticket metadata and additional attributes
- Ticket expiration and validation periods
- Secondary market functionality for ticket resale

## License

This project is open source and available under the MIT License.