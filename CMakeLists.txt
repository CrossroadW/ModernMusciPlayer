cmake_minimum_required(VERSION 3.16)

project(untitled1 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)
file(GLOB SOURCES "*.cpp" "*.h")
qt_add_executable(appuntitled1
   ${SOURCES}
)

qt_add_qml_module(appuntitled1
    URI untitled1
    VERSION 1.0
    RESOURCES qml.qrc res.qrc
)


target_link_libraries(appuntitled1
    PRIVATE Qt6::Quick
)
target_link_directories(appuntitled1 PRIVATE /home/awe/Desktop/dev/install/lib64)

target_link_libraries(appuntitled1 PRIVATE
    ssl
    crypto
)

set_target_properties(appuntitled1 PROPERTIES
    INSTALL_RPATH "/home/awe/Desktop/dev/install/lib64"
)
