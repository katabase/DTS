import glob
import xml.etree.ElementTree as ET
from lxml import etree
import sys

def main(input_dir):
    '''
    Cette fonction produit un document xml-tei maître permettant de lier chaque division entre elles.
    :param input_file: le temoin à traiter sans extension pour l'instant
    :return: None
    '''
    corpus_file = "corpus.xml"
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


        with open("corpus_file_out.xml", "w") as outfile:
            outfile.write(etree.tostring(corpus_file).decode())


def changement_path(corpus):
    with open(corpus, "r") as corpus_file:
        corpus_file = etree.parse(corpus_file)
        string_corpus = etree.tostring(corpus_file).decode()
        print(type(string_corpus))
        string_corpus = string_corpus.replace("_tagged", "")
        string_corpus = string_corpus.replace("xml/", "output_xml/")

        with open("corpus_file_out2.xml", "w") as outfile:
            outfile.write(string_corpus)


if __name__ == "__main__":
    if sys.argv[1] == "1":
        files = "xml/*.xml"
        main(files)
    else:
        changement_path("corpus_file_out.xml")