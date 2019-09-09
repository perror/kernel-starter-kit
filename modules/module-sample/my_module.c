#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Anonymous Developer");
MODULE_DESCRIPTION("Test module");
MODULE_VERSION("1.0");

/* Initialisation function */
static int __init my_module_init(void)
{
	pr_info("module: Module inserted!\n");
	return 0;
}

/* Cleanup function */
static void __exit my_module_exit(void)
{
	pr_info("module: Module removed!\n");
}

module_init(my_module_init);
module_exit(my_module_exit);
