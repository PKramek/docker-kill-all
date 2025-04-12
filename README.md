# Docker-Kill-All

A Zsh utility that provides a convenient command to terminate all running Docker containers with enhanced reporting and container ID tracking. Works great on Pop OS and other Linux distributions.

## Features

- Kill all running Docker containers with a single command
- Option to gracefully stop containers instead of force killing
- Display container IDs and names before operations
- Detailed success/failure reporting for each container
- Built-in confirmation prompt to prevent accidental termination
- Zsh command completion integration
- Error handling for Docker daemon connectivity issues

## Prerequisites

- Zsh shell (can be installed via `sudo apt install zsh`)
- Docker installed and running
- Terminal access

## Installation

### Automatic Installation

```bash
# Clone the repository
git clone https://github.com/[your-username]/docker-kill-all.git

# Run the installation script
cd docker-kill-all
chmod +x add_docker_kill_all.sh
./add_docker_kill_all.sh

# Activate the function in your current session
source ~/.zshrc
```

### Manual Installation

If you prefer to install manually, you can add the function directly to your `~/.zshrc` file:

- Copy the `docker-kill-all` function to your `~/.zshrc file`
- Activate the function `source ~/.zshrc`

### Uninstallation

To remove the function from your Zsh, manually remove the function from ~/.zshrc

## Usage

### Basic usage (with confirmation prompt)
`docker-kill-all`

### Force kill without confirmation
`docker-kill-all -f`

### Gracefully stop containers instead of killing
`docker-kill-all -s`

### Display help information
`docker-kill-all -h`

## Example Output

```bash
Found 3 running containers:
  -  abc123def456 (nginx-proxy)
  -  fed987cba654 (mysql-db)
  -  123abc456def (redis-cache)

This will kill ALL running Docker containers listed above.
Are you sure you want to continue? (y/n) y

Killing all containers...

Results:
Successfully terminated containers:
  ✓ abc123def456 (nginx-proxy)
  ✓ fed987cba654 (mysql-db)
  ✓ 123abc456def (redis-cache)

All containers have been terminated successfully.
```

## How It Works

The script adds a function to your Zsh configuration that:

1. Retrieves a list of all running Docker containers
2. Displays their IDs and names
3. Asks for confirmation (unless forced with -f)
4. Terminates each container using either `docker kill` or `docker stop`
5. Reports on the success or failure of each operation

## Troubleshooting

### Common Issues

- `Command not found`: Make sure you've sourced your `.zshrc` file after installation
- `Docker daemon not running`: Ensure Docker is running with `systemctl status docker`
- `Permission denied`: You may need to add your user to the docker group with: `sudo usermod -aG docker $USER` Then log out and back in

### Docker Connection Issues

If you see `Error: Cannot connect to Docker daemon`, try:

- Check if Docker is running: `systemctl status docker`
- Start Docker if it's not running: `sudo systemctl start docker`

## Compatibility

- Tested on: Pop OS 22.04, Ubuntu 20.04, Debian 11
- Requires: Zsh 5.0+ and Docker 19.03+
- Version: 1.0.0

## Security Considerations

⚠️ `Warning`: This tool will terminate ALL running Docker containers. Use with caution in production environments. It's primarily designed for development and testing environments.

## License

The MIT License (MIT)

Copyright (c) 2025 Piotr Kramek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Contributing

Contributions are welcome! Feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
