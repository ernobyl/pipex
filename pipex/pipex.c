/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: emichels <emichels@student.hive.fi>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/01/09 10:53:50 by emichels          #+#    #+#             */
/*   Updated: 2024/01/25 12:25:39 by emichels         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	first_child_process(char **argv, char **envp, int *fd)
{
	int	filein;

	filein = open(argv[1], O_RDONLY);
	if (filein == -1)
		handle_error(EXIT_FAILURE, "open error");
	if (dup2(fd[1], STDOUT_FILENO) == -1)
		handle_error(EXIT_FAILURE, "child1: fd duplication error");
	close(fd[0]);
	if (dup2(filein, STDIN_FILENO) == -1)
		handle_error(EXIT_FAILURE, "child1: fd duplication error");
	execute(argv[2], envp);
}

void	second_child_process(char **argv, char **envp, int *fd)
{
	int	fileout;

	fileout = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (fileout == -1)
		handle_error(EXIT_FAILURE, "open error");
	if (dup2(fd[0], STDIN_FILENO) == -1)
		handle_error(EXIT_FAILURE, "child2: fd duplication error");
	close(fd[1]);
	if (dup2(fileout, STDOUT_FILENO) == -1)
		handle_error(EXIT_FAILURE, "child2: fd duplication error");
	execute(argv[3], envp);
}

int	main(int argc, char **argv, char **envp)
{
	t_pipex	pipex;
	int		fd[2];
	int		exit_status;

	if (argc != 5)
		handle_error(EXIT_FAILURE, "Format: './pipex file1 cmd1 cmd2 file2'");
	if (pipe(fd) == -1)
		handle_error(EXIT_FAILURE, "pipe error");
	pipex.pid1 = fork();
	if (pipex.pid1 == 0)
		first_child_process(argv, envp, fd);
	pipex.pid2 = fork();
	if (pipex.pid2 == 0)
		second_child_process(argv, envp, fd);
	close(fd[0]);
	close(fd[1]);
	waitpid(pipex.pid1, &pipex.status1, 0);
	waitpid(pipex.pid2, &pipex.status2, 0);
	exit_status = 0;
	if (WIFEXITED(pipex.status1))
		exit_status = WEXITSTATUS(pipex.status1);
	if (WIFEXITED(pipex.status2))
		exit_status = WEXITSTATUS(pipex.status2);
	exit(exit_status);
}
