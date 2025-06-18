import os
from xml.etree.ElementTree import Element, SubElement, tostring
from xml.dom import minidom

def scan_qml_files(base_dir):
    files = []
    for root, _, filenames in os.walk(base_dir):
        for filename in filenames:
            full_path = os.path.join(root, filename)
            relative_path = os.path.relpath(full_path, start=base_dir)
            files.append(os.path.join(base_dir, relative_path).replace("\\", "/"))
    return sorted(files)

def generate_qrc(base_dir, qrc_output_path):
    rcc = Element("RCC")
    qresource = SubElement(rcc, "qresource", prefix="/")

    for file in scan_qml_files(base_dir):
        SubElement(qresource, "file").text = file

    xml_str = minidom.parseString(tostring(rcc)).toprettyxml(indent="    ")
    with open(qrc_output_path, "w", encoding="utf-8") as f:
        f.write(xml_str)

# 示例调用
generate_qrc("src/qml", "qml.qrc")
