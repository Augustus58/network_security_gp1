import socket

def main():
    while True:
        i = input('m for message, e for exit: ')
        if i == 'm':
            s = socket.socket()
            host = 'localhost'
            port = 8080
            s.connect((host, port))
            print('connecting to ' + str(s.getpeername()))
            data = s.recv(1024)
            print('response: ' + data.decode('utf-8'))
            s.close
        if i == 'e':
            break;    
        
if __name__ == "__main__":
    main()
