#include <QObject>
#include <QQuickItem>

class QmlWriter : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE void save(QQuickItem *game, QString filename);

private:
    QString dumpRecursive(QObject *item, QString tab);

};
