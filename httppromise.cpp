#include "httppromise.h"
#include <QDebug>
#include <QTimer>

HttpPromise::HttpPromise(QObject *parent) : QObject(parent) {}

// HttpPromise *HttpPromise::then(QJSValue callback) {
//     thenCallback = callback;
//     return this;
// }

// HttpPromise *HttpPromise::error(QJSValue callback) {
//     catchCallback = callback;
//     return this;
// }

// void HttpPromise::resolve(QString result, QString url) {
//     if (settled) {
//         qWarning() << " HttpPromise::resolve error: settled=> " << settled;

//         return;
//     }
//     settled = true;
//     QJSValue cb = thenCallback;
//     QTimer::singleShot(0, [this, cb, result, url]() mutable {
//         cb.call(QJSValueList{result, url});
//         deleteLater();
//     });
// }

// void HttpPromise::reject(QString error, QString url) {
//     if (settled) {
//         qWarning() << " HttpPromise::reject error: settled=> " << settled;
//         return;
//     }
//     settled = true;
//     QJSValue cb = catchCallback;
//     QTimer::singleShot(0, [this, cb, error, url]() mutable {
//         cb.call(QJSValueList{error, url});
//         deleteLater();
//     });
// }

// void HttpPromise::doSuccess(QString result, QString url) {
//     if (settled) {
//         qWarning() << " HttpPromise::resolve error: settled=> " << settled;
//         return;
//     }
//     settled = true;

//     Q_EMIT successSig(result, url);
// }

// void HttpPromise::doError(QString error, QString url) {
//     if (settled) {
//         qWarning() << " HttpPromise::reject error: settled=> " << settled;
//         return;
//     }
//     settled = true;

//     Q_EMIT successSig(error, url);
// }
