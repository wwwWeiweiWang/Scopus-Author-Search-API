This is a bash version of Scopus Author Search API: https://dev.elsevier.com/scopus.html#!/Author_Search/AuthorSearch

1. go to https://dev.elsevier.com/apikey/manage to get your API keys, and put in line 3. apikey=

2. go to https://service.elsevier.com/app/contact/supporthub/dataasaservice/ to request a token, and put in line 4. token=

3. prepare your input file to replace HRexample.csv on line 7. The first column is the person's university ID. You may use any ID easier for you to identify the person.

4. run the code in a Linux/Unix terminal. command: bash scopus.api.searchauthors.sh

5. output: ScopusIDs.csv