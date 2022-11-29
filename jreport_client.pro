QT += quick network widgets

CONFIG += c++17
QMAKE_CXXFLAGS += -std=c++17

SOURCES += main.cpp \
    downloader.cpp
RESOURCES += qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=

HEADERS += \
    downloader.h
