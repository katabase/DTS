import glob
import xml.etree.ElementTree as ET
from lxml import etree
import sys
import subprocess

def main(input_dir):
    '''
    This function creates a tei:teiCorpus main file
    :param input_file: le temoin à traiter sans extension pour l'instant
    :return: None
    '''
    corpus_file = "corpus_model.xml"
    xinclude_list = []
    for file in glob.glob(input_dir):
        x_include = f"<xi:include href=\"{file}\" xmlns:xi=\"http://www.w3.org/2001/XInclude\"/>"
        xinclude_list.append(x_include)

    tei = {'tei': 'http://www.tei-c.org/ns/1.0'}
    with open(corpus_file, "r") as corpus_file:
        corpus_file = etree.parse(corpus_file)
        tei_list = f"<teiCorpus>{' '.join(xinclude_list)}</teiCorpus>"
        body = corpus_file.xpath("//tei:teiCorpus", namespaces=tei)[0]
        body.insert(1, etree.fromstring(tei_list))
        with open("corpus_file.xml", "w") as outfile:
            outfile.write(etree.tostring(corpus_file).decode())

def transformation_xml_1():
    '''
    This function modificates the xml:id of the descs and items to fit with Capitains Guidelines
    :return:
    '''
    saxon = 'saxon9he.jar'
    cmd = f'java -jar {saxon} -xi:on corpus_file.xml data_fitting.xsl'
    subprocess.run(cmd.split())


def transformation_xml_2():
    '''
    This fuction creates a folder compliant with Nautilus requirements.
    :return:
    '''
    saxon = 'saxon9he.jar'
    cmd = f'java -jar {saxon} -xi:on final_corpus_file.xml to_nautilus.xsl'
    subprocess.run(cmd.split())



def changement_path(corpus):
    with open(corpus, "r") as corpus_file:
        corpus_file = etree.parse(corpus_file)
        string_corpus = etree.tostring(corpus_file).decode()
        print(type(string_corpus))
        string_corpus = string_corpus.replace("_tagged", "")
        string_corpus = string_corpus.replace("xml/", "output_xml/")

        with open("final_corpus_file.xml", "w") as outfile:
            outfile.write(string_corpus)


if __name__ == "__main__":
    files = "xml/*.xml"
    main(files)
    transformation_xml_1()
    changement_path("corpus_file.xml")
    transformation_xml_2()