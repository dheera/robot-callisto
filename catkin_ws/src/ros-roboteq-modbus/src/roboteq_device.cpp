#include "roboteq_device.h"

void log(std::string text) {
  std::cout << text << "\n";
}

RoboteqDevice::RoboteqDevice(std::string _port, int _baud, int _num_channels) {
  port = _port;
  baud = _baud;
  num_channels = _num_channels;
  if(!connect()) log("could not connect to roboteq");
}

RoboteqDevice::~RoboteqDevice() {
  disconnect();
}

bool RoboteqDevice::connect() {
  try {
      ser.setPort(port);
      ser.setBaudrate(baud);
      serial::Timeout to = serial::Timeout::simpleTimeout(1000);
      ser.setTimeout(to);
      ser.open();

      // put roboteq in modbus ascii mode
      ser.write("^DMOD 3\r\n");
      ser.readline();

  } catch(serial::IOException& e) {
      return false;
  }

  if(!ser.isOpen()) {
      return false;
  }

  return true;
}

bool RoboteqDevice::disconnect() {
  ser.close();
  return true;
}

void RoboteqDevice::commandGo(unsigned int channel, int value) {
  ser.write(modbusWriteHoldingRegisters(COMMAND_G, channel, value));
  std::cout << ser.readline();
}

const std::vector<int> RoboteqDevice::getBrushlessCount() {
  std::vector<int> result;
  for(int i=1;i<=num_channels;i++) {
    ser.write(modbusReadInputRegisters(QUERY_CB, i));
    result.push_back((int)modbusParseQueryResponse(ser.readline()));
  }
  return result;
}

const std::vector<double> RoboteqDevice::getBrushlessSpeed() {
  std::vector<double> result;
  for(int i=1;i<=num_channels;i++) {
    ser.write(modbusReadInputRegisters(QUERY_CB, i));
    result.push_back((double)modbusParseQueryResponse(ser.readline()));
  }
  return result;
}

const std::vector<int> RoboteqDevice::getClosedLoopError() {
  std::vector<int> result;
  for(int i=1;i<=num_channels;i++) {
    ser.write(modbusReadInputRegisters(QUERY_E, i));
    result.push_back((int)modbusParseQueryResponse(ser.readline()));
  }
  return result;
}

const std::vector<double> RoboteqDevice::getCurrent() {
  std::vector<double> result;
  for(int i=1;i<=num_channels;i++) {
    ser.write(modbusReadInputRegisters(QUERY_A, i));
    result.push_back((double)(int)modbusParseQueryResponse(ser.readline()) / 10.0);
  }
  return result;
}

const std::vector<unsigned int> RoboteqDevice::getFirmwareID() {
  std::vector<unsigned int> result;
  for(int i=1;i<=4;i++) {
    ser.write(modbusReadInputRegisters(QUERY_FIN, i));
    result.push_back((unsigned int)modbusParseQueryResponse(ser.readline()));
  }
  return result;
}

const std::vector<unsigned int> RoboteqDevice::getFlagsRuntime() {
  std::vector<unsigned int> result;
  for(int i=1;i<=num_channels;i++) {
    ser.write(modbusReadInputRegisters(QUERY_FM, i));
    result.push_back((unsigned int)modbusParseQueryResponse(ser.readline()));
  }
  return result;
}

const unsigned int RoboteqDevice::getFlagsStatus() {
  ser.write(modbusReadInputRegisters(QUERY_FS, 1));
  return (unsigned int)modbusParseQueryResponse(ser.readline());
}

const unsigned int RoboteqDevice::getFlagsFault() {
  ser.write(modbusReadInputRegisters(QUERY_FF, 1));
  return (unsigned int)modbusParseQueryResponse(ser.readline());
}

const std::vector<double> RoboteqDevice::getVoltage() {
  std::vector<double> result = {0.0,0.0,0.0};

  ser.write(modbusReadInputRegisters(QUERY_V, 1));
  result[0] = (double)(signed int)modbusParseQueryResponse(ser.readline()) / 10.0;

  ser.write(modbusReadInputRegisters(QUERY_V, 2));
  result[1] = (double)(signed int)modbusParseQueryResponse(ser.readline()) / 10.0;

  ser.write(modbusReadInputRegisters(QUERY_V, 3));
  result[2] = (double)(signed int)modbusParseQueryResponse(ser.readline()) / 1000.0;

  return result;
}

unsigned char RoboteqDevice::LRC(std::vector<unsigned char> msg) {
  unsigned char sum = 0;
  for(auto i=0;i<(int)msg.size();i++) sum += msg[i];
  return (unsigned char)(-(char)sum);
}  

uint32_t RoboteqDevice::modbusParseQueryResponse(std::string input) {
  std::istringstream iss(input);

  char start;
  iss >> start;
  if(start != ':') return 0;
  
  iss >> std::hex;
  
  std::string s;

  iss >> std::setw(2) >> s;
  unsigned int node = std::stoul(s, nullptr, 16);
  
  iss >> std::setw(2) >> s;
  unsigned int function_code = std::stoul(s, nullptr, 16);
  
  iss >> std::setw(2) >> s;
  unsigned int data_length = std::stoul(s, nullptr, 16);

  iss >> std::setw(8) >> s;
  unsigned long int data = std::stoul(s, nullptr, 16);
  
  iss >> std::setw(2) >> s;
  unsigned int lrc = std::stoul(s, nullptr, 16);

  return data;
}

const std::string RoboteqDevice::modbusWriteHoldingRegisters(unsigned int reg, unsigned int offset, uint32_t value) {
  std::vector<unsigned char> msg_bytes = {
    0x01, // node address
    0x10, // function code (write multiple holding registers)
    0x00, 0x00, // register address -- to be filled in
    0x00, 0x02, // write 2 registers
    0x04, // write 4 bytes
    0x00, 0x00, 0x00, 0x00 // value -- to be filled in
  };

  reg += offset;

  msg_bytes[2] = reg >> 8;
  msg_bytes[3] = reg & 0xFF;

  // roboteq is big indian
  msg_bytes[7] = (value & 0xFF000000) >> 24;
  msg_bytes[8] = (value & 0x00FF0000) >> 16;
  msg_bytes[9] = (value & 0x0000FF00) >> 8;
  msg_bytes[10] = (value & 0x000000FF);

  msg_bytes.push_back(LRC(msg_bytes));
  std::stringstream output;

  output << ":";
  output << std::hex << std::setfill('0');

  for(auto i=0;i < (int)msg_bytes.size(); i++) {
    output << std::setw(2) << static_cast<unsigned>(msg_bytes[i]);
  }

  output << "\r\n";
  return output.str();
}

const std::string RoboteqDevice::modbusReadInputRegisters(unsigned int reg, unsigned int offset) {
  std::vector<unsigned char> msg_bytes = {
    0x01, // node address
    0x04, // function code (read input registers)
    0x00, 0x00, // register address -- to be filled in
    0x00, 0x02, // read 2 bytes
  };

  reg += offset;

  msg_bytes[2] = reg >> 8;
  msg_bytes[3] = reg & 0xFF;

  msg_bytes.push_back(LRC(msg_bytes));
  std::stringstream output;

  output << ":";
  output << std::hex << std::setfill('0');

  for(auto i=0;i < (int)msg_bytes.size(); i++) {
    output << std::setw(2) << static_cast<unsigned>(msg_bytes[i]);
  }

  output << "\r\n";
  return output.str();
}

