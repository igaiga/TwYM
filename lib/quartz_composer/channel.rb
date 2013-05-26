module QuartzComposer
  class Channel
    DEFAULT_IP_ADDRESS = '225.0.0.0'

    attr_reader :address, :port

    def initialize(port, address: DEFAULT_IP_ADDRESS)
      @address = address
      @port = port
    end

    def <<(message)
      socket.send  message.encode('UTF-32BE'), 0
      self
    end

    private

    def socket
      @socket ||= create_socket
    end

    def create_socket
      socket = UDPSocket.open
      socket.connect(address, port)
      socket
    end
  end
end
