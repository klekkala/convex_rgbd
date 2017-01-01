awk -f ex.awk out.txt > result.txt
sed 's/xx/ /' < result.txt > r1.txt
sed 's/,/ /' < r1.txt > result.txt

