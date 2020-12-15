cmake_minimum_required(VERSION 2.8.3)
project(elevator_move_base_fetch)

find_package(catkin REQUIRED
  cv_bridge
  geometry_msgs
  image_geometry
  image_transport
  roscpp
  std_msgs
  tf
)

include_directories(${catkin_INCLUDE_DIRS})

catkin_package(
  DEPENDS
  CATKIN_DEPENDS
  INCLUDE_DIRS
  LIBRARIES
)

add_executable(color_point_detector src/color_point_detector.cpp)
target_link_libraries(color_point_detector ${catkin_LIBRARIES})

install(
  DIRECTORY config elevator_numbers launch node_scripts sample scripts
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS
)

install(
  TARGETS color_point_detector
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
