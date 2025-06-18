#include "httpclient.h"
#include "httppromise.h"
#include "httpsignal.h"
#include <QGuiApplication>
#include <qqml.h>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QCoreApplication::setOrganizationName("Binaryify");
    QCoreApplication::setOrganizationDomain("binaryify.cn");
    QCoreApplication::setApplicationName("CloudMusicPlayer");
    // qmlRegisterType<HttpClient>("Http", 1, 0, "HttpClient");
    qmlRegisterType<HttpPromise>("Http", 1, 0, "HttpPromise");
    qmlRegisterType<HttpSignal>("Http", 1, 0, "HttpSignal");
    engine.rootContext()->setContextProperty("HttpClient", new HttpClient);

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
        []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(QUrl("qrc:/src/qml/Main.qml"));

    return app.exec();
}
