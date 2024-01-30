##Setup Linux Server

## 1 - SSH into Linux Server:  
ssh username@<your-server-ip>


## 2 - Update System Packages

sudo apt update
sudo upgrade

## 3 - Install Python

sudo apt install python3
sudo apt install python3-pip
sudo apt install git
pip install instructor
uvicorn --version
pip install --upgrade uvicorn
pip install --upgrade starlette urllib3
pip install --upgrade fastapi
pip install --upgrade botocore

## 4 - Setup Virtual Environment

python3 --version

python3 -m venv myenv
source myenv/bin/activate  


## 5 - Install and Configure Web Server (Nginx)

 # Install Nginx: sudo apt install nginx
 # Start Nginx: sudo systemctl start nginx
 # Enable Nginx to start on boot: sudo systemctl enable nginx
 


## 6 - Install Required Python Packages
pip install -r requirements.txt


## 7 - Configure Firewall(UFW):

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8000/tcp
sudo ufw allow OpenSSH

	#Check listening ports
	ss -tuln | grep 8000


 # Allow HTTP and HTTPS:
  sudo ufw allow 'Nginx Full'

sudo ufw enable


## Create Your Python Application
## Clone/Create App: Clone your Git repo or upload your Python API files to the server.
## Create a Directory: For instance, mkdir ~/myapi and put your Python API files here.


## 8 - Set Up Domain

If you have a domain, configure DNS settings to point to your server's IP address. You may also need to set up an A or CNAME record depending on your DNS provider.


## 9 - Secure SSH Access

sudo nano /etc/ssh/sshd_config

## Set PasswordAuthentication to no, then restart the SSH service:
sudo systemctl restart sshd
d


## 10 - Install Uvicorn


## 11 - Configure Nginx for Your Application

 # Create a new Nginx server block config: 
  sudo nano /etc/nginx/sites-avaiable/myapi

 # Configure the sever block.  Example configuration:


  server {
    listen 80;
    server_name your_domain_or_IP;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
 


# Enable the file by linking: 
sudo ln -s /etc/nginx/sites-available/myapi /etc/nginx/sites-enabled

# Test Nginx config: sudo nginx -t

# Restart Nginx:
 sudo systemctl restart nginx

#reload nginx: sudo systemctl daemon-reload
#start nginx: sudo systemctl start myapi.services
#stop nginx: sudo sytemctl stop myapi.services


## 12 - Autostart Your Application

	# Create a systemd service file: 
	sudo nano /etc/systemd/system/myapi.service

	
	service config file:

	[Unit]
	Description=Gunicorn instance to serve myapi
	After=network.target

	[Service]
	User=your_username
	Group=www-data
	WorkingDirectory=/home/your_username/myapi
	Environment="PATH=/home/your_username/myapi/venv/bin"
	ExecStart=/home/your_username/myapi/venv/bin/gunicorn --workers 3 --bind unix:myapi.sock -m 007 wsgi:app
	Restart=on-failure
	RestartSec=5s
	
	[Install]
	WantedBy=multi-user.target

	# Start the service
	sudo systemctl start myapi
	sudo systemctl enble myapi

## 13 - Secure API
	# Set up HTTPS using Let's Encrypt and Certbot



## 14 - Manual Uvicorn start
	uvicorn main:app --host 0.0.0.0 --port 8000 --log-level debug



## 15 - Verify DNS Config

	nslookup akilapi.kitwanaakil.com


## 16 - Create a Directory for Your Subdomain
	sudo mkdir /var/www/subdomain

## 17 - Configure Nginx
	sudo nano /etc/nginx/sites-available/subdomain

	config file:

	server {
	    listen 80;
    	    server_name subdomain.yourdomain.com;
    	    root /var/www/subdomain;
    	    # You can add additional configuration options here if needed
	}



	# save the file
	# create a symbolic link to enable the server block:

		sudo ln -s /etc/nginx/sites-available/subdomain /etc/nginx/sites-enabled/

	# Test the Nginx configuration for syntax errors
		sudo nginx -t


	# if no errors reload Nginx to apply changes
		sudo systemctl reload nginx


# 18 - Getting around the cffi module not found error

	# Install python 3.10
	sudo apt remove python3-cffi
	sudo python3 -m pip install cffi


# 19 - Solve the module not found error:  AttributeError: module 'lib' has no attribute 'X509_V_FLAG_NOTIFY_POLICY'. Did you mean: 'X509_V_FLAG_EXPLICIT_POLICY'?

	sudo rm -rf /usr/lib/python3/dist-packages/OpenSSL
	sudo pip3 install pyopenssl
	sudo pip3 install pyopenssl --upgrade

