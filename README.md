# Purchase Orders API

Rails REST API to receive purchase orders, group them on batches, follow the orders in the production pipeline until the dispatch and generate some simple financial report.

### To run the project you need:

Ruby 3.0.2 \
Rails 7.0.4 \
PostgreSQL

### Dependencies

Install the necessary dependencies:

```
  $ bundle install
```

### Database

Create the database:
Add environment variables according to the file ```application.example.yml``` and then run the commands:

```
  $ rails db:create
  $ rails db:migrate
```

### Run the application

```
  $ rails s
```

## Entities

### Order

An Order is composed by the data needed to produce and dispatch a purchase by a client. It's composed of the following properties:

- Reference (e.g. BR102030)
- Purchase Channel (e.g. Site BR)
- Client Name (e.g. Rogerio Lima)
- Address (e.g. Rua Padre Valdevino, 2475 - Aldeota, Fortaleza - CE, 60135-041)
- Delivery Service (e.g. SEDEX)
- Total Value (e.g. R$ 123.30)
- Line Items (these are the instructions needed to produce the items, it does not follows an strict structure, e.g. [{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}, {sku: powebank-sunshine, capacity: 10000mah}, {sku: earphone-standard, color: white}] )
- Status: ready (a new order, ready to be produced), production (waiting to be printed), closing (already produced, waiting to be sent), sent (on the way to the client).

### Batch

A Batch is a group of Orders following the same production pipeline. Before starting producing the Orders, an operator will take all available orders that are ready and group them on a Batch. It's composed of the following properties:

- Reference (e.g. 201803-54)
- Purchase Channel (e.g. Site BR)
- A group of orders.

## Endpoints

### GET /orders
This endpoint returns all orders \
By default there are 10 orders per page \
You can pass the following parameters to this endpoint: \

`by_client_name` \
(e.g. '/orders?by_client_name=Natalia') \

`by_purchase_channel` \
(e.g. '/orders?by_purchase_channel=Site BR') \

`by_reference` \
(e.g. '/orders?by_reference=ORDER-12092022-1') \

`by_status`\
(e.g. '/orders?by_status=sent')

`page`\
(e.g. '/orders?page=2')

### GET /orders/:id
This endpoint returns an order and you must pass the order id as a parameter

### GET /batches/:id/orders
This endpoint returns all orders for a batch \
By default there are 10 orders per page \
You can pass the following parameters to this endpoint: \

`page`\
(e.g. '/batches/:id/orders?page=2')

### POST /orders
In this endpoint you create a order, you must pass the following information in the body of the request:

```
    "order": {
        "client_name": "Name",
        "address": "Address",
        "purchase_channel": "Channel",
        "delivery_service": "Delivery service",
        "total_value": 100,
        "line_items": [
            { "sku": "item one" },
            { "sku": "item two" }
        ]
    }
```

### GET /batches
This endpoint returns all batches \
By default there are 10 batches per page \
You can pass the following parameters to this endpoint: \

`page`\
(e.g. '/batches?page=2')

### GET /batches/:id
This endpoint returns an batch and you must pass the batch id as a parameter

### PATCH /batches/:id/produce
This endpoint pass a batch from production to closing and you must pass the batch id as a parameter

### PATCH /batches/:id/close_by_delivery_service
This endpoint those batch orders should be marked as sent and you must pass the batch id and delivery_service as a parameter

`delivery_service`\
(e.g. '/batches/1/close_by_delivery_service?delivery_service=Sedex')

### POST /batches
In this endpoint you create a batch, you must pass the following information in the body of the request:
```
    "batch": {
        "purchase_channel": "Site BR",
        "order_ids": [4, 5]
    }
```

### GET /financial_report
This endpoint returns a financial report, where orders are grouped by purchase channels, returning the total quantity and total value of orders.
e.g.:
```
    [
      {
          "puchase_channel": "Site BR",
          "orders_total_count": 3,
          "orders_total_value": 200.0
      },
      {
          "puchase_channel": "Loja Iguatemi",
          "orders_total_count": 1,
          "orders_total_value": 100.0
      },
      {
          "puchase_channel": "Site US",
          "orders_total_count": 1,
          "orders_total_value": 100.0
      }
    ]
```

## Future improvements
- Using a Rack Attack gem, to intercept calls before they reach the controllers, creating methods that filter as calls, allowing only what is within the standard we have established to pass.
- Use Brakeman to scan code and find vulnerabilities.
- Implement user authentication.
- Implement a web interface to the application.

