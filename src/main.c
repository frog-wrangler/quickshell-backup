
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/statvfs.h>

static unsigned long cpu_idle;
static unsigned long cpu_total;
static long cpu_temp;

static unsigned gpu_perc; // TODO
static long gpu_temp; // TODO

static unsigned long mem_used;
static unsigned long mem_total;
static unsigned mem_perc;

static unsigned long disk_id;

static unsigned long kb_read;
static unsigned long kb_written;

static unsigned long storage_used;
static unsigned long storage_total;
static unsigned storage_perc;

void cpu_info()
{
    // Usage
    FILE* file = fopen("/proc/stat", "r");

    char buffer[128];
    fgets(buffer, sizeof(buffer), file);
    fclose(file);

    char* current = buffer + 4;
    cpu_total = 0;
    for (int i = 0; i < 7; ++i) {
        while (*(++current) == ' ') { }
        unsigned long num = strtoul(current, NULL, 10);
        current = strchr(current, ' ');

        cpu_total += num;
        if (i == 3) {
            cpu_idle = num;
        }
    }

    // Temperature
    long sum_temps = 0;
    unsigned i = 0;
    char temp_buf[16];
    char path[] = "/sys/class/thermal/thermal_zone?/temp";
    for (char num = '0'; num <= '9'; ++num) {
        path[31] = num;
        FILE* file = fopen(path, "r");
        if (!file) {
            break;
        }

        fgets(temp_buf, sizeof(temp_buf), file);
        fclose(file);
        sum_temps += strtol(temp_buf, NULL, 10);
        i++;
    }
    cpu_temp = sum_temps / i;
}

void mem_info()
{
    FILE* file = fopen("/proc/meminfo", "r");

    char buffer[128];
    fgets(buffer, sizeof(buffer), file);
    mem_total = strtoul(strchr(buffer, ':') + 1, NULL, 10);

    fgets(buffer, sizeof(buffer), file);

    fgets(buffer, sizeof(buffer), file);
    mem_used = mem_total - strtoul(strchr(buffer, ':') + 1, NULL, 10);

    fclose(file);

    mem_perc = 1000 * ((float)mem_used / mem_total);
}

/// Only evaluates first disk
void disk_info()
{
    // Usage/space
    struct statvfs disk;
    if (statvfs("/", &disk)) {
        perror("Error on disk info");
        exit(EXIT_FAILURE);
    }

    unsigned long block_size = disk.f_bsize;
    storage_total = (disk.f_blocks / 1000) * block_size;
    storage_used = storage_total - (disk.f_bfree / 1000) * block_size;
    storage_perc = 1000 * ((float)storage_used / storage_total);

    // I/O
    char buffer[256];
    FILE* file = fopen("/proc/diskstats", "r");
    fgets(buffer, sizeof(buffer), file);
    fclose(file);

    disk_id = strtoul(buffer, NULL, 10);

    char* current = buffer;
    for (unsigned i = 0; i < 5; ++i) {
        current = strchr(current, ' ');
        while (*(++current) == ' ') { }
    }
    kb_read = strtoull(current, NULL, 10) * block_size / 1000;

    for (unsigned i = 0; i < 4; ++i) {
        current = strchr(current, ' ');
        while (*(++current) == ' ') { }
    }
    kb_written = strtoull(current, NULL, 10) * block_size / 1000;
}

void print_info()
{
    printf(
        "%lu\n"
        "%lu\n"
        "%ld\n"
        "%u\n"
        "%ld\n"
        "%lu\n"
        "%lu\n"
        "%u\n"
        "%lu\n"
        "%lu\n"
        "%lu\n"
        "%lu\n"
        "%lu\n"
        "%u\n",
        cpu_idle,
        cpu_total,
        cpu_temp,

        gpu_perc,
        gpu_temp,

        mem_used,
        mem_total,
        mem_perc,

        disk_id,
        kb_read,
        kb_written,
        storage_used,
        storage_total,
        storage_perc);

    // puts(
    //     "\nOrder: (all percentages are whole numbers out of 1000)\n"
    //     "Cpu Idle\n"
    //     "Cpu Total\n"
    //     "Cpu Temperature (mC)\n"
    //
    //     "Gpu Percent\n"
    //     "Gpu Temperature (mC)\n"
    //
    //     "Memory Used (kB)\n"
    //     "Memory Total (kB)\n"
    //     "Memory Percent\n"
    //
    //     "Disk ID\n"
    //     "Bytes Read (kB)\n"
    //     "Bytes Written (kB)\n"
    //     "Storage Used (kB)\n"
    //     "Storage Total (kB)\n"
    //     "Storage Percent");
}

int main()
{
    cpu_info();
    mem_info();
    disk_info();

    print_info();
    return EXIT_SUCCESS;
}
