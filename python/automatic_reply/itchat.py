import itchat
from itchat.content import TEXT

@itchat.msg_register(TEXT)
def text_reply(msg):
    # 自动回复
    return '收到：{}'.format(msg['Text'])

# 登录微信
itchat.auto_login(hotReload=True)

# 运行微信
itchat.run()
