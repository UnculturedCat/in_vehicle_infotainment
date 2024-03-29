cmake_minimum_required(VERSION 3.21.1)

option(LINK_INSIGHT "Link Qt Insight Tracker library" ON)
option(BUILD_QDS_COMPONENTS "Build design studio components" ON)

project(in_vehicle_infotainmentApp LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

#find_package(X11 REQUIRED)
find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Qml Quick Positioning Location)

if (Qt6_VERSION VERSION_GREATER_EQUAL 6.3)
    qt_standard_project_setup()
endif()

add_subdirectory(src/Models)

qt_add_executable(in_vehicle_infotainmentApp src/main.cpp
    src/controllers/mapscontroller.h src/controllers/mapscontroller.cpp
    src/Models/searchmodel.h src/Models/searchmodel.cpp
    src/Models/CMakeLists.txt
)

qt_add_resources(in_vehicle_infotainmentApp "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

target_link_libraries(in_vehicle_infotainmentApp PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Positioning
    Qt6::Location
)

if (BUILD_QDS_COMPONENTS)
    include(${CMAKE_CURRENT_SOURCE_DIR}/qmlcomponents)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/qmlmodules)


if (LINK_INSIGHT)
    include(${CMAKE_CURRENT_SOURCE_DIR}/insight)
endif ()

include(GNUInstallDirs)
install(TARGETS in_vehicle_infotainmentApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# make IDEs aware of the QML import path
set(QML_IMPORT_PATH ${PROJECT_BINARY_DIR}/qml CACHE PATH
    "Path to the custom QML components defined by the project")
