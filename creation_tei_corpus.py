import glob
import xml.etree.ElementTree as ET
from lxml import etree
import sys
import subprocess

def corpus_creation(input_dir):
    '''
    This function creates a tei:teiCorpus main file
    :param input_file: le temoin à traiter sans extension pour l'instant
    :return: None
    '''
    corpus_file = "model_files/corpus_model.xml"
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


def corpus_to_nautilus():
    '''
    This fuction creates a folder compliant with Nautilus requirements.
    :return:
    '''
    saxon = 'saxon9he.jar'
    cmd = f'java -jar {saxon} -xi:on corpus_file.xml xsl/to_nautilus.xsl'
    subprocess.run(cmd.split())



if __name__ == "__main__":
    files = "xml/*.xml"
    corpus_creation(files)
    corpus_to_nautilus()


# On reprend le tout:
# - un dossier d'entrée avec tous les fichiers à modifier
# - un dossier de sortie directement nautilus ?