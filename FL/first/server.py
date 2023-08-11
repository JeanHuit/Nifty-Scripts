import socket
import threading
import pickle

class Server:
    def __init__(self):
        self.global_model = {'slope': 0.5, 'intercept': 2.0}
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind(('localhost', 12345))
        self.server_socket.listen(5)
        self.client_sockets = []

    def start(self):
        while True:
            client_socket, _ = self.server_socket.accept()
            self.client_sockets.append(client_socket)
            threading.Thread(target=self.handle_client, args=(client_socket,)).start()

    def handle_client(self, client_socket):
        client_data = pickle.loads(client_socket.recv(1024))
        client_socket.sendall(b'ACK')

        self.aggregate([client_data])
        client_socket.close()

    def aggregate(self, client_updates):
        new_slope = 0.0
        new_intercept = 0.0

        for update in client_updates:
            new_slope += update['slope']
            new_intercept += update['intercept']

        self.global_model['slope'] = new_slope / len(client_updates)
        self.global_model['intercept'] = new_intercept / len(client_updates)
