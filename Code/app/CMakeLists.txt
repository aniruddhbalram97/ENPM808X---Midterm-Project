FIND_PACKAGE( OpenCV REQUIRED )   

add_executable(shell-app main.cpp human_object_detector.cpp)
include_directories(
    ${CMAKE_SOURCE_DIR}/include
)
INCLUDE_DIRECTORIES( ${OpenCV_INCLUDE_DIRS} )
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/coco.names
     DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
TARGET_LINK_LIBRARIES (shell-app ${OpenCV_LIBS}) 

