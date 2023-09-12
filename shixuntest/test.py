import os
import docx2txt
from PyPDF2 import PdfReader

#search_folder函数用于遍历给定文件夹路径中的所有文件，并根据文件类型选择相应的搜索函数
def search_folder(folder_path, keyword):
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            if file.lower().endswith('.txt'):
                search_file(file_path, keyword)
            elif file.lower().endswith('.docx'):
                text = convert_docx_to_text(file_path)
                search_text(file_path, text, keyword)
            elif file.lower().endswith('.pdf'):
                text = convert_pdf_to_text(file_path)
                search_text(file_path, text, keyword)

#convert_docx_to_text函数使用docx2txt库将给定的word文件转换为纯文本，并返回转换后的文本内容
def convert_docx_to_text(file_path):
    text = docx2txt.process(file_path)
    return text

#convert_pdf_to_text函数使用PyPDF2库将给定的PDF文件转换为纯文本，并返回提取后的文本内容
def convert_pdf_to_text(file_path):
    with open(file_path, 'rb') as file:
        pdf = PdfReader(file)
        text = ''
        for page in pdf.pages:
            text += page.extract_text()
        return text

#search_file函数用于相应文件（file_path），搜索其包含关键字的内容行
#它逐行读取文件内容，使用enumerate函数获得行号，然后判断行中是否包含关键字，并将匹配的行号和内容添加到found_lines列表中。
#最后，如果found_lines不为空，则按格式输出；如果found_lines，则不进行输出
def search_file(file_path, keyword):
    found_lines = []
    with open(file_path, 'r', encoding='utf-8') as file:
        for line_number, line in enumerate(file, start=1):
            if keyword in line:
                found_lines.append((line_number, line.strip()))
    if found_lines:
        print(file_path)
        print('-' * len(file_path))
        for line_number, line in found_lines:
            print(f"行号{line_number}\t{line}")
        print()

#search_text函数用于在给定的文本内容text中，搜索包含关键字的内容行
#它使用split('\n')方法将文本拆分为行，并使用enumerate函数获得行号，然后判断行中是否包含关键字，并将匹配的行号和内容添加到found_lines列表中
#最后，如果found_lines不为空，则按格式输出；如果found_lines，则不进行输出
def search_text(file_path, text, keyword):
    found_lines = []
    for line_number, line in enumerate(text.split('\n'), start=1):
        if keyword in line:
            found_lines.append((line_number, line.strip()))
    if found_lines:
        print(file_path)
        print('-' * len(file_path))
        for line_number, line in found_lines:
            print(f"行号{line_number}\t{line}")
        print()

#主函数，用于启动
if __name__ == '__main__':
    folder_path = r'D:\123'  # 替换为你的文件夹路径
    keyword = '4'

    search_folder(folder_path, keyword)
