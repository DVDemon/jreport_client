#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QtWebView>
#include <QQuickWindow>
#include <QSGRendererInterface>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts );
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;


    QFontDatabase::addApplicationFont(":/fonts/CorpidE1SCd_Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/CorpidE1SCd_Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/CorpidE1SCd_Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-BoldItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-Italic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Hack-Regular.ttf");

    const QUrl url(u"qrc:/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
