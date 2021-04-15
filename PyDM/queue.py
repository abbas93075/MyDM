class Queue:
    def __init__(self):
        self.length = 0
        self.data = []


    def is_empty(self):
        return  self.length == 0

    def enqueue(self,data):
        self.data.append(data)
        self.length+=1

    def peek(self):
        if self.is_empty():
            return
        return self.data[0]

    def dequeue(self):
        if self.is_empty():
            return
        value = self.data[0]
        del(self.data[0])
        self.length -= 1
        return value

