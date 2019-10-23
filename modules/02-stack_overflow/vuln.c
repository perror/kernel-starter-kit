#include <linux/fs.h>
#include <linux/module.h>
#include<linux/proc_fs.h>
#include <linux/uaccess.h>

MODULE_AUTHOR("Anonymous Author");
MODULE_DESCRIPTION("Vulnerable kernel module");
MODULE_LICENSE("GPL");
MODULE_VERSION("1.0");

static ssize_t vuln_write(struct file *file, const char *user_buffer,
			  size_t size, loff_t *offset)
{
	char buffer[8];
        memcpy (buffer, user_buffer, size);

        return size;
}

static struct file_operations vuln_fops = {
        .owner   = THIS_MODULE,
        .write   = vuln_write,
};


/* Initialisation function */
int init_module(void)
{
        if (!proc_create("vuln", 0644, NULL, &vuln_fops))
                return -1;      

	pr_info("vuln: module loaded!\n");
	return 0;
}

/* Cleanup function */
void cleanup_module(void)
{
	remove_proc_entry("vuln", NULL);
	pr_info("vuln: module unloaded!\n");
}
