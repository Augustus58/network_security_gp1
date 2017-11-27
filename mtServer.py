import socket
import threading
import datetime
import time
        
def handleRequest(c, addr):
    timeNow = datetime.datetime.now().strftime("%I:%M%p on %B %d, %Y")
    c.send(('Hello! Time is ' + timeNow).encode('utf-8'))
    print('requester address: ' + str(c.getpeername()))
    c.close()

def main():
    s = socket.socket()
    host = '10.3.0.5'
    port = 8080
    s.bind((host, port))
    s.listen(5)
    while True:
        (c, addr) = s.accept()
        thread = threading.Thread(target=handleRequest, args=(c, addr))
        thread.start()

if __name__ == "__main__":
    main()
