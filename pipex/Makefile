CC = cc
CFLAGS = -Wall -Wextra -Werror
LDFLAGS = -Llibft -lft

SRCS = pipex.c \
		pipex_utils.c \

NAME = pipex

${NAME}: ${SRCS}
	make -C libft
	${CC} ${CFLAGS} ${SRCS} ${LDFLAGS} -o ${NAME}

all: ${NAME}

clean:
	make clean -C libft

fclean: clean
	rm -f ${NAME}
	make fclean -C libft

re: fclean all

.PHONY: all clean fclean re