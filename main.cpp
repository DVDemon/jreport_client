#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
//#include <QtWebView>
#include <QQuickWindow>
#include <QSGRendererInterface>

#include "downloader.h"

int main(int argc, char *argv[])
{
//    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts );
 //   QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;


    QFontDatabase::addApplicationFont(":/fonts/CorpidE1SCd_Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/CorpidE1SCd_Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/CorpidE1SCd_Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-BoldItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-Italic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-Regular.ttf");

    Downloader down1,down2,down3,down4,down5,down6,down7,down8,down9,down10;
    engine.rootContext()->setContextProperty("Downloader1",&down1);
    engine.rootContext()->setContextProperty("Downloader2",&down2);
    engine.rootContext()->setContextProperty("Downloader3",&down3);
    engine.rootContext()->setContextProperty("Downloader4",&down4);
    engine.rootContext()->setContextProperty("Downloader5",&down5);
    engine.rootContext()->setContextProperty("Downloader6",&down6);
    engine.rootContext()->setContextProperty("Downloader7",&down7);
    engine.rootContext()->setContextProperty("Downloader8",&down8);
    engine.rootContext()->setContextProperty("Downloader9",&down9);
    engine.rootContext()->setContextProperty("Downloader10",&down10);

    const QUrl url("qrc:/main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
