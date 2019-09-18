#include <linux/module.h>

/* Initialisation function */
int init_module(void)
{
	pr_info("module: Module inserted!\n");
	return 0;
}

/* Cleanup function */
void cleanup_module(void)
{
	pr_info("module: Module removed!\n");
}
