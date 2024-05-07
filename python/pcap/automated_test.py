import paramiko
import time
import re

def execute_commands_with_sudo(hostname, username, password, commands):
    results = {}
    try:
        # 创建SSH客户端
        client = paramiko.SSHClient()
        # 自动添加主机名和主机密钥到主机列表中
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        # 连接服务器
        client.connect(hostname=hostname, username=username, password=password)
        
        for command in commands:
            # 创建交互式shell
            shell = client.invoke_shell()
            # 发送sudo命令
            shell.send(f'sudo {command}\n')
            time.sleep(1)  # 等待一段时间以确保命令发送成功
            
            # 接收输出
            output = ''
            while True:
                if shell.recv_ready():
                    output += shell.recv(1024).decode()
                else:
                    time.sleep(0.5)
                if re.search(r'\[sudo\] password', output):
                    shell.send(f'{password}\n')
                    time.sleep(1)  # 等待一段时间以确保密码发送成功
                elif re.search(r'\$ ', output):
                    break
            
            # 将输出保存到结果字典中
            results[command] = output
        
        # 关闭连接
        client.close()
        
    except Exception as e:
        print("An error occurred:", str(e))
    
    return results

# 设置服务器的地址、用户名和密码
hostname = '192.168.30.237'
username = 'sensemi'
password = '1'

# 要执行的指令列表
commands = ['pwd', 'ls -l', 'whoami']

# 调用函数执行命令
command_results = execute_commands_with_sudo(hostname, username, password, commands)

# 打印每个命令的输出
for command, result in command_results.items():
    print(f"Command: {command}")
    print("Output:")
    print(result)
