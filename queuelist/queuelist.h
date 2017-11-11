#ifndef __QUEUELIST_H__
#define __QUEUELIST_H__


#define QUEUELIST_DEBUG_ON

#if defined(GLOBAL_DEBUG_ON)
#define QUEUELIST_DEBUG_ON
#endif
#if defined(QUEUELIST_DEBUG_ON)
#define QUEUELIST_DEBUG(format, ...) os_printf("[QUEUELIST]"format, ##__VA_ARGS__)
#else
#define QUEUELIST_DEBUG(format, ...)
#endif


#ifdef __cplusplus
extern "C"{
#endif

typedef struct queue_t
{
    uint8_t length;
    uint8_t* content;
}queue_t;

#define 	DMESSAGE_POINTER queue_t

void init_queuelist (void);
bool inser_queuelist_tail (DMESSAGE_POINTER *structdata);
void delete_queuelist_head (void);
DMESSAGE_POINTER* get_queuelist_head_data (void);


#ifdef __cplusplus
}
#endif
#endif /* __QUEUELIST_H__ */
