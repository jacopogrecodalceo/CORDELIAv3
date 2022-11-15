require 'socket'

host = "localhost"  # Standard loopback interface address (localhost)
port = 10015  # Port to listen on (non-privileged ports are > 1023)

#udp.connect(host, port)
udp = UDPSocket.new

begin
	udp.bind(host, port)
rescue Errno::EADDRINUSE => ex
	p "nooo"
	udp.close
end
