#!/bin/bash

TEST='infile.txt'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

parameters1=("./pipex" "${TEST}" "wc -l" "cat" "outfile1.txt")
parameters2=("./pipex" "${TEST}" "grep a" "sed s/a/A/g" "outfile2.txt")
parameters3=("./pipex" "${TEST}" "ls -l" "cat" "grep 1" "cat")
parameters4=("./pipex" "${TEST}" "ls -l")
parameters5=("./pipex" "${TEST}" "/bin/cat" "wc -w" "outfile5.txt")
parameters6=("./pipex" "poopoo" "cat" "wc -l" "outfile6.txt")
parameters7=("./pipex" "${TEST}" "poopoo" "wc -l" "outfile7.txt")
parameters8=("./pipex" "${TEST}" "cat" "poopdypoo" "outfile8.txt")
parameters9=("./pipex" "${TEST}" "cat" "wc -w" "outfile9.txt")
parameters10=("./pipex" "${TEST}" "" "" "outfile10.txt")

perform_test()
{
	echo -e "${RED}------RUNNING-TESTS------${NC}"
	echo -e "${CYAN}test 1 with parameters: ${parameters1[@]}${NC}"
	"${parameters1[@]}"
	echo -e "${CYAN}test 2 with parameters: ${parameters2[@]}${NC}"
	"${parameters2[@]}"
	echo -e "${CYAN}test 3 with too many parameters${NC}"
	"${parameters3[@]}"
	echo -e "${CYAN}test 4 with too few parameters${NC}"
	"${parameters4[@]}"
	echo -e "${CYAN}test 5: full address of command: ${parameters5[@]}${NC}"
	"${parameters5[@]}"
	echo -e "${CYAN}test 6 with invalid first argument (infile)${NC}"
	"${parameters6[@]}"
	echo -e "${CYAN}test 7 with invalid second argument (1st command)${NC}"
	"${parameters7[@]}"
	echo -e "${CYAN}test 8 with invalid third argument (2nd command)${NC}"
	"${parameters8[@]}"
	touch outfile9.txt && chmod 0111 outfile9.txt
	echo -e "${CYAN}test 9 with outfile open error${NC}"
	"${parameters9[@]}"
	echo -e "${CYAN}test 10 with an empty string as a command argument${NC}"
	"${parameters10[@]}"
	echo -e "${RED}------CHECKING-OUTPUT-FILES------${NC}"
	echo -e "${CYAN}outfile1.txt:${NC}" && cat outfile1.txt
	echo -e "${CYAN}outfile2.txt:${NC}" && cat outfile2.txt
	echo -e "${CYAN}outfile5.txt:${NC}" && cat outfile5.txt
	echo -e "${CYAN}outfile6.txt:${NC}" && cat outfile6.txt
	echo -e "${CYAN}outfile7.txt:${NC}" && cat outfile7.txt
	echo -e "${CYAN}outfile8.txt:${NC}" && cat outfile8.txt
	echo -e "${CYAN}outfile9.txt:${NC}" && chmod 0644 outfile9.txt && cat outfile9.txt
	echo -e "${CYAN}outfile10.txt:${NC}" && cat outfile10.txt
	echo -e "${RED}------END-OF-TEST------${NC}"
}

remove_files()
{
	echo "Removing test output files"
	rm outfile1.txt
	rm outfile2.txt
	rm outfile5.txt
	rm outfile6.txt
	rm outfile7.txt
	rm outfile8.txt
	chmod 0777 outfile9.txt && rm outfile9.txt
	rm outfile10.txt
}

if [ "$1" == "remove" ]; then
	remove_files
else
	perform_test
fi