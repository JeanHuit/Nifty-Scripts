import threading
from server import Server
from client import Client

# Simulated data points (x, y)
data = [
    (1, 2),
    (2, 4),
    (3, 6),
    (4, 8),
    (5, 10)
]

NUM_CLIENTS = 5
NUM_ROUNDS = 10

server = Server()
server_thread = threading.Thread(target=server.start)
server_thread.start()

clients = []
data_per_client = [data[i:i + len(data) // NUM_CLIENTS] for i in range(0, len(data), len(data) // NUM_CLIENTS)]

# Create and initialize client instances
for client_data in data_per_client:
    client = Client(client_data)
    clients.append(client)

# Federated Learning loop
for _ in range(NUM_ROUNDS):
    for client in clients:
        client.train()
        client.send_update()

    print(f"Round {_ + 1} - Global Model: Slope: {server.global_model['slope']}, Intercept: {server.global_model['intercept']}")

server_thread.join()
