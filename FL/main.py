import socket
import threading
import pickle
import random

class Server:
    def __init__(self):
        self.global_model = {'slope': 0.5, 'intercept': 2.0}
        self.trust_scores = {}
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind(('localhost', 12345))
        self.server_socket.listen(5)
        self.client_sockets = []

    def start(self):
        try:
            while True:
                client_socket, _ = self.server_socket.accept()
                self.client_sockets.append(client_socket)
                threading.Thread(target=self.handle_client, args=(client_socket,)).start()
        finally:
            self.server_socket.close()

    def handle_client(self, client_socket):
        try:
            client_data = pickle.loads(client_socket.recv(1024))
            client_socket.sendall(b'ACK')

            client_update, trust_feedback = client_data['update'], client_data['trust_feedback']
            self.update_trust(client_socket, trust_feedback)
            self.aggregate([client_update])
        finally:
            client_socket.close()

    def aggregate(self, client_updates):
        new_slope = 0.0
        new_intercept = 0.0

        for update in client_updates:
            new_slope += update['slope']
            new_intercept += update['intercept']

        self.global_model['slope'] = new_slope / len(client_updates)
        self.global_model['intercept'] = new_intercept / len(client_updates)

    def update_trust(self, client_socket, trust_feedback):
        if client_socket in self.client_sockets:
            self.trust_scores[client_socket] = self.trust_scores.get(client_socket, 0) + trust_feedback

class Client:
    def __init__(self, local_data):
        self.local_data = local_data
        self.local_model = {'slope': 1.0, 'intercept': 0.0}
        self.trust_scores = {}
        self.peer_clients = []

    def train(self):
        for x, y in self.local_data:
            predicted = self.local_model['slope'] * x + self.local_model['intercept']
            error = predicted - y

            self.local_model['slope'] -= 0.01 * error * x
            self.local_model['intercept'] -= 0.01 * error

    def update_server(self):
        return self.local_model

    def send_update(self):
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            client_socket.connect(('localhost', 12345))
            update_data = {
                'update': self.update_server(),
                'trust_feedback': self.assess_trustworthiness()
            }
            client_socket.sendall(pickle.dumps(update_data))
            ack = client_socket.recv(1024)
        finally:
            client_socket.close()

    def receive_feedback(self, peer_client, feedback):
        self.trust_scores[peer_client] = feedback

    def assess_trustworthiness(self):
        if not self.trust_scores:
            return 1.0
        return sum(self.trust_scores.values()) / len(self.trust_scores)

# Rest of the code remains the same...

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

for client_data in data_per_client:
    client = Client(client_data)
    clients.append(client)

for client in clients:
    client.peer_clients = [peer for peer in clients if peer != client]

# for _ in range(NUM_ROUNDS):
#     for client in clients:
#         client.train()
#         client.send_update()

#     for client in clients:
#         trust = client.assess_trustworthiness()
#         for peer in client.peer_clients:
#             peer.receive_feedback(client, trust + random.uniform(-0.1, 0.1))

#     print(f"Round {_ + 1} - Global Model: Slope: {server.global_model['slope']}, Intercept: {server.global_model['intercept']}")

# ... (previous code)

# Federated Learning loop
for round_num in range(NUM_ROUNDS):
    for client in clients:
        client.train()
        client.send_update()

    for client in clients:
        trust = client.assess_trustworthiness()
        for peer in client.peer_clients:
            peer.receive_feedback(client, trust + random.uniform(-0.1, 0.1))

    print(f"Round {round_num + 1} - Global Model: Slope: {server.global_model['slope']}, Intercept: {server.global_model['intercept']}")

    # Print each client's local model and trust score
    print("Client Results and Trust Scores:")
    for client in clients:
        print(f"Client {clients.index(client) + 1} - Local Model: Slope: {client.local_model['slope']}, Intercept: {client.local_model['intercept']} - Trust Score: {client.assess_trustworthiness()}")

server_thread.join()


# server_thread.join()
