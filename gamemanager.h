#include <QObject>
#include <QQuickItem>
#include <QString>
#include <QQmlContext>

class GameManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)

public:
    GameManager(QQmlContext *context);
    Q_INVOKABLE void save(QQuickItem *game);
    Q_INVOKABLE void open(QString path);
    Q_INVOKABLE void create(QString name);
    QString name() { return m_name; }

signals:
    void nameChanged();

private:
    QString dumpRecursive(QObject *item, QString tab);
    QQmlContext *m_context;
    QString m_name;
};
