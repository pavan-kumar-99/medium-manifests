from locust import HttpUser, task, between

class HelloWorldUser(HttpUser):
    wait_time = between(0.5, 2.5)

    @task(3)
    def health(self):
        response = self.client.get('/api/health')
        if (response.status_code == 200):
            print("Health request Success")
    
    @task(6)
    def login(self):
        response = self.client.post("/login", data = {"username":"admin", "password":"prom-operator"})
        if (response.status_code == 200):
            print("Login Success")
