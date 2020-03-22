#include <roboteq_device.h>

#include <iostream>
#include <iomanip>
#include <vector>
#include <cstdlib>
#include <cstring>
#include <sstream>

#include <chrono>
#include <thread>

int main() {
  RoboteqDevice r("/dev/roboteq0", 115200, 2);

  std::vector<unsigned int> fid = r.getFirmwareID();
  std::string fid_string;
  for (const auto &piece : fid) fid_string += std::to_string(piece) + ".";
  std::cout << "Firmware ID: " << fid_string << "\n";

  int i;

  for(i=0;i<200;i++) {
    r.commandGo(1,i);
    r.commandGo(2,i);
    std::this_thread::sleep_for(std::chrono::milliseconds(20));
  }

  for(i=200;i>=0;i--) {
    r.commandGo(1,i);
    r.commandGo(2,i);
    std::this_thread::sleep_for(std::chrono::milliseconds(20));
  }

  for(i=0;i<200;i++) {
    r.commandGo(1,-i);
    r.commandGo(2,-i);
    std::this_thread::sleep_for(std::chrono::milliseconds(20));
  }

  for(i=200;i>=0;i--) {
    r.commandGo(1,-i);
    r.commandGo(2,-i);
    std::this_thread::sleep_for(std::chrono::milliseconds(20));
  }

  while(true) {
    std::vector<int> cb = r.getBrushlessCount();
    std::cout << "CB " << cb[0] << " " << cb[1] << "   ";

    std::vector<double> v = r.getVoltage();
    std::cout << "V " << v[0] << " " << v[1] << " " << v[2] << "\n";
    std::this_thread::sleep_for(std::chrono::milliseconds(20));
  }
  return 0;
}
