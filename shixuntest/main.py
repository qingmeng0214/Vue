from threading import Lock
from flask import Flask, render_template, request, jsonify
import os
import docx2txt
from flask_cors import CORS
from PyPDF2 import PdfReader
from werkzeug.utils import secure_filename
import re
from tkinter import Tk
from tkinter.filedialog import asksaveasfilename

app = Flask(__name__)
CORS(app, supports_credentials=True)
# 创建全局变量来保存临时文件夹路径
TEMP_FOLDER = None
# 创建互斥锁
lock = Lock()


# 进入界面
@app.route("/")
def index():
    return render_template("index.html")


# 硬盘选择
@app.route('/api/getDrives', methods=['GET'])
def get_drives():
    drives = []
    for drive in os.popen('wmic logicaldisk get name').readlines():
        drive = drive.strip()
        if len(drive) == 2:
            drives.append(drive)
    return jsonify(drives)


# 获取文件夹
@app.route('/api/getDirectory', methods=['POST'])
def get_directory():
    path = request.json['path']
    files = []
    directories = []
    for item in os.listdir(path):
        item_path = os.path.join(path, item)
        if os.path.isfile(item_path):
            files.append({'name': item, 'path': item_path})
        else:
            directories.append({
                'name': item,
                'path': item_path,
                'isDirectory': True
            })
    return jsonify(directories + files)


# 获取到前端的数据信息
@app.route("/get_data", methods=["POST"])
def get_data():
    # 接受前端的数据
    global TEMP_FOLDER
    data = request.get_json()
    path = data.get('path')
    files = data.get('files')

    # 在这里对获取到的数据进行处理或执行其他操作
    TEMP_FOLDER = path  # 更新全局变量的值
    # 返回响应给前端
    print(files)
    response = {'message': '数据接收成功'}
    return jsonify(response)


# 检索功能
@app.route("/search", methods=["POST"])
def search():
    # 检索功能
    keyword = request.form.get("keyword")
    temp_folder1 = TEMP_FOLDER  # 使用全局变量

    print("Keyword:", keyword)
    print("Uploaded Folder:", temp_folder1)

    results = []
    if temp_folder1:
        for root, dirs, files in os.walk(temp_folder1):
            for file in files:
                if file.startswith("~$"):
                    continue  # 跳过以 "~$" 开头的文件
                file_path = os.path.join(root, file)
                print("------------------------------1------------------")
                print(file_path)
                if file.lower().endswith('.txt'):
                    lines = search_file(file_path, keyword)
                    if lines:
                        results.append({'file': file_path, 'lines': lines})
                elif file.lower().endswith('.docx'):
                    text = convert_docx_to_text(file_path)
                    lines = search_text(file_path, text, keyword)
                    if lines:
                        results.append({'file': file_path, 'lines': lines})
                elif file.lower().endswith('.pdf'):
                    text = convert_pdf_to_text(file_path)
                    lines = search_text(file_path, text, keyword)
                    if lines:
                        results.append({'file': file_path, 'lines': lines})
                else:
                    continue  # 跳过处理，继续下一个文件的循环迭代
    if results:
        # 为每一行添加 selected 属性，默认为 False
        for item in results:
            for i in range(len(item['lines'])):
                line = list(item['lines'][i])
                line.append(False)  # 添加 selected 属性，默认为 False
                item['lines'][i] = tuple(line)
        print(results)
        return jsonify({'message': '文件检索成功'}, results)

    else:
        return jsonify({'message': '文件检索失败'})


@app.route('/api/uploadFiles', methods=['POST'])
def upload_files():
    files = request.files.getlist('files')
    if len(files) == 0:
        return jsonify({'message': 'No files selected'}), 400

    uploaded_files = []
    for file in files:
        filename = secure_filename(file.filename)
        file.save(os.path.join('uploads', filename))
        uploaded_files.append(filename)

    return jsonify({
        'message': 'Files uploaded successfully',
        'uploaded_files': uploaded_files
    })


# 保存数据函数，可以将正确格式的数据保存到当前目录
# 保存数据函数，可以将正确格式的数据保存到指定位置
# 保存路由
@app.route("/save", methods=["POST"])
def save():
    # 获取用户要保存的数据
    select_results = request.get_json()
    print(select_results)
    save_data(select_results)
    return jsonify({'message': '文件保存成功'})


# 保存文件函数
def save_data(data):
    # 创建根窗口
    root = Tk()
    # 隐藏根窗口
    root.withdraw()

    # 弹出文件对话框，让用户选择保存文件的位置和名称
    file_path = asksaveasfilename(defaultextension=".txt",
                                  filetypes=[("Text Files", "*.txt")])

    # 用户取消选择时，file_path 为空字符串
    if file_path:
        # 打开文件进行写入
        # 使用互斥锁保护文件访问
        with lock:
            with open(file_path, "w", encoding='utf-8') as file:
                # 写入文件的逻辑...
                for result in data["results"]:
                    file.write("------------------\n")
                    file.write("{}\n".format(result['path']))
                    file.write("------------------\n")
                    for line_number, line_content in result["lines"].items():
                        file.write(f"行号{line_number}  :  {line_content}\n")
                    file.write("\n")

        print("Data saved successfully.")
    else:
        print("Save operation canceled.")


# 划分text的函数
def split_lines(text):
    lines = re.findall(r'.+?(?:\r\n|\r|\n|$)', text)
    return lines


# convert_docx_to_text函数使用docx2txt库将给定的word文件转换为纯文本，并返回转换后的文本内容
def convert_docx_to_text(file_path):
    text = docx2txt.process(file_path)
    text = split_lines(text)
    return text


# convert_pdf_to_text函数使用PyPDF2库将给定的PDF文件转换为纯文本，并返回提取后的文本内容
def convert_pdf_to_text(file_path):
    with open(file_path, 'rb') as file:
        pdf = PdfReader(file)
        text = ''
        for page in pdf.pages:
            text += page.extract_text()
        text = split_lines(text)
        return text


# search_file函数用于相应文件（file_path），搜索其包含关键字的内容行
# 它逐行读取文件内容，使用enumerate函数获得行号，然后判断行中是否包含关键字，并将匹配的行号和内容添加到found_lines列表中。
# 最后，如果found_lines不为空，则按格式输出；如果found_lines，则不进行输出
def search_file(file_path, keyword):
    found_lines = []
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
        # 执行文件读取操作
        for line_number, line in enumerate(file, start=1):
            if keyword in line:
                found_lines.append((line_number, line.strip()))
    return found_lines


# search_text函数用于在给定的文本内容text中，搜索包含关键字的内容行
# 它使用split('\n')方法将文本拆分为行，并使用enumerate函数获得行号，然后判断行中是否包含关键字，并将匹配的行号和内容添加到found_lines列表中
# 最后，如果found_lines不为空，则按格式输出；如果found_lines，则不进行输出
def search_text(file_path, text, keyword):
    found_lines = []
    for line_number, line in enumerate(text, start=1):
        if keyword in line:
            found_lines.append((line_number, line.strip()))
    return found_lines


if __name__ == "__main__":
    app.run()
