#ifndef HTTPPROMISE_H
#define HTTPPROMISE_H

#include <QJSValue>
#include <QObject>
#include <QString>

class HttpPromise : public QObject {
    Q_OBJECT
public:
    explicit HttpPromise(QObject *parent);

    // Q_INVOKABLE HttpPromise *then(QJSValue callback);
    // Q_INVOKABLE HttpPromise *error(QJSValue callback);
    // void resolve(QString result, QString url);
    // void reject(QString error, QString url);

    // void doSuccess(QString result, QString url);
    // void doError(QString error, QString url);

Q_SIGNALS:
    void success(QString result, QString url);
    void error(QString error, QString url);

private:
    // QJSValue thenCallback;
    // QJSValue catchCallback;
    // bool settled = false;
};

#endif // HTTPPROMISE_H
