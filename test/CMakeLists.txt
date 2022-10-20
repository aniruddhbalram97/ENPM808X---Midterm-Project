set(GTEST_SHUFFLE 1)
FIND_PACKAGE( OpenCV REQUIRED )   
add_executable(
    cpp-test
    main.cpp
    test.cpp
    human_object_detector_test.cpp
)

INCLUDE_DIRECTORIES( ${OpenCV_INCLUDE_DIRS} )
target_include_directories(cpp-test PUBLIC ../vendor/googletest/googletest/include 
                                           ${CMAKE_SOURCE_DIR}/include )

target_link_libraries(cpp-test PUBLIC gtest ${OpenCV_LIBS})
