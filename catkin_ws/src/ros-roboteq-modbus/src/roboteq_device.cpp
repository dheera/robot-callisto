#include "roboteq_device.h"

void log(std::string text) {
  std::cout << text << "\n";
}

RoboteqDevice::RoboteqDevice(std::string _port, int _baud) {
  port = _port;
  baud = _baud;
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

const std::vector<double> RoboteqDevice::getVoltage() {
  std::vector<double> result = {0.0,0.0,0.0};

  ser.write(modbusQueryString(QUERY_V, 1));
  result[0] = (double)(signed int)modbusParseQueryResponse(ser.readline()) / 10.0;

  ser.write(modbusQueryString(QUERY_V, 2));
  result[1] = (double)(signed int)modbusParseQueryResponse(ser.readline()) / 10.0;

  ser.write(modbusQueryString(QUERY_V, 3));
  result[2] = (double)(signed int)modbusParseQueryResponse(ser.readline()) / 1000.0;

  return result;
}

const std::vector<double> RoboteqDevice::getCurrent() {
  std::vector<double> result = {0.0,0.0};

  ser.write(modbusQueryString(QUERY_A, 1));
  result[0] = (double)(int)modbusParseQueryResponse(ser.readline()) / 10.0;

  ser.write(modbusQueryString(QUERY_A, 2));
  result[1] = (double)(int)modbusParseQueryResponse(ser.readline()) / 10.0;

  return result;
}

const std::vector<int> RoboteqDevice::getBrushlessCount() {
  std::vector<int> result = {0,0};

  ser.write(modbusQueryString(QUERY_CB, 1));
  result[0] = (int)modbusParseQueryResponse(ser.readline());

  ser.write(modbusQueryString(QUERY_CB, 2));
  result[1] = (int)modbusParseQueryResponse(ser.readline());

  return result;
}

unsigned char RoboteqDevice::LRC(std::vector<unsigned char> msg) {
  unsigned char sum = 0;
  for(auto i=0;i<(int)msg.size();i++) sum += msg[i];
  return (unsigned char)(-(char)sum);
}  

unsigned long int RoboteqDevice::modbusParseQueryResponse(std::string input) {
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

const std::string RoboteqDevice::modbusQueryString(unsigned int query, unsigned int index) {
  std::vector<unsigned char> msg_bytes = {
    0x01, // node address
    0x04, // function code (read input registers)
    0x00, 0x00, // register address -- to be filled in
    0x00, 0x02, // read 2 bytes
  };

  query += index;

  msg_bytes[2] = query >> 8;
  msg_bytes[3] = query & 0xFF;

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

