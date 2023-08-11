# client.py
import socket
import pickle
import random

class Client:
    def __init__(self, local_data):
        self.local_data = local_data
        self.local_model = {'slope': 1.0, 'intercept': 0.0}
        self.trust_scores = {}  # Store trust scores for other clients
        self.peer_clients = []   # List of connected peer clients

    def train(self):
        for x, y in self.local_data:
            predicted = self.local_model['slope'] * x + self.local_model['intercept']
            error = predicted - y

            # Gradient descent update
            self.local_model['slope'] -= 0.01 * error * x
            self.local_model['intercept'] -= 0.01 * error

    def update_server(self):
        return self.local_model

    def send_update(self):
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect(('localhost', 12345))
        client_socket.sendall(pickle.dumps(self.update_server()))
        ack = client_socket.recv(1024)
        client_socket.close()

    def receive_feedback(self, peer_client, feedback):
        self.trust_scores[peer_client] = feedback

    def assess_trustworthiness(self):
        if not self.trust_scores:
            return 1.0  # Default trust for new clients

        # Calculate the average trust score received from peer clients
        return sum(self.trust_scores.values()) / len(self.trust_scores)
