

#include "mem.h"
#include "osapi.h"
#include "os_type.h"
#include "queuelist.h"



typedef struct queuelist_t
{
    struct queuelist_t* head;
    struct queuelist_t* tail;
    DMESSAGE_POINTER *queue;
}queuelist_t;
static queuelist_t *headQueue = NULL;
static queuelist_t *tailQueue = NULL;
static uint8_t 	count=1;


bool verify_queuelist_data (DMESSAGE_POINTER* structdata) 
{
	// QUEUELIST_DEBUG("%s head:%d\n", structdata->content, structdata->length);
	if(structdata->content==NULL || structdata->length==0)
		return false;
	return true;
}
DMESSAGE_POINTER* malloc_queuelist_data (DMESSAGE_POINTER* structdata) 
{
	if(structdata->content==NULL || structdata->length==0)
		return NULL;
	DMESSAGE_POINTER *tempQueue = (DMESSAGE_POINTER*)os_malloc(sizeof(DMESSAGE_POINTER));
	if(tempQueue == NULL)
		return NULL;
	tempQueue->content = (uint8_t*)os_malloc((structdata->length+1)*sizeof(uint8_t));
	if(tempQueue->content == NULL){
		os_free(tempQueue);
		return NULL;
	}
	os_memcpy(tempQueue->content, structdata->content, structdata->length);
	tempQueue->content[structdata->length] = '\0';
	// QUEUELIST_DEBUG("%s malloc_queuelist_data:%d\n", tempQueue->content, tempQueue->length);
	return tempQueue;
}
void free_queuelist_data (DMESSAGE_POINTER* structdata) 
{
	if(structdata != NULL){
		if(structdata->content != NULL){
			os_free(structdata->content);
			structdata->content = NULL;
			structdata->length = 0;
		}
		os_free(structdata);
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////list////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void init_queuelist (void) 
{
	queuelist_t *tempQueue = (queuelist_t*)os_malloc(sizeof(queuelist_t));
	count = 1;
	tempQueue->queue = NULL;
	headQueue = tempQueue;
	tailQueue = tempQueue;
	tempQueue->head = headQueue;
	tempQueue->tail = tailQueue;
	QUEUELIST_DEBUG("%s head:%p tail:%p\n", __func__, headQueue, tailQueue);
}


bool inser_queuelist_tail (DMESSAGE_POINTER *structdata) 
{
	DMESSAGE_POINTER *datatemp=NULL;
	queuelist_t *queuetemp = (queuelist_t*)os_malloc(sizeof(queuelist_t));
	if(queuetemp == NULL || structdata == NULL || !verify_queuelist_data(structdata))
		return false;
	queuetemp->queue = NULL;
	queuetemp->tail = headQueue->head;
	queuetemp->head = tailQueue->tail;
	datatemp = malloc_queuelist_data(structdata);
	// QUEUELIST_DEBUG("%s inser_queuelist_tail:%d\n", datatemp->content, datatemp->length);
	if(datatemp == NULL){
		os_free(queuetemp);
		return false;
	}
	tailQueue->queue = datatemp;
	tailQueue->tail = queuetemp;
	tailQueue = queuetemp;
	count++;
	QUEUELIST_DEBUG("queuelist %d\n", count);
	return true;
}
void delete_queuelist_head (void) 
{
	if(headQueue->queue != NULL){
		free_queuelist_data(headQueue->queue);
	}
	headQueue->queue = NULL;
	if(tailQueue != headQueue){
		headQueue = headQueue->tail;
		os_free(headQueue->head);
		headQueue->head = tailQueue->tail;
		count--;
	}else{
		headQueue->head = headQueue->tail;
		headQueue->tail = headQueue->head;
		tailQueue = headQueue;
		count = 1;
	}
	QUEUELIST_DEBUG("queuelist %d\n", count);
}
DMESSAGE_POINTER* get_queuelist_head_data (void) 
{
	return headQueue->queue;
}


void queuelist_test (void) 
{
	init_queuelist();
	uint8_t buf1[]="123456789";
	DMESSAGE_POINTER *testbuf1 = (DMESSAGE_POINTER*)os_malloc(sizeof(DMESSAGE_POINTER));
	testbuf1->length = sizeof(buf1);
	testbuf1->content = (uint8_t*)os_malloc(testbuf1->length*sizeof(uint8_t));
	os_memcpy(testbuf1->content, buf1, testbuf1->length);

	uint8_t buf2[]="3125sadg9";
	DMESSAGE_POINTER *testbuf2 = (DMESSAGE_POINTER*)os_malloc(sizeof(DMESSAGE_POINTER));
	testbuf2->length = sizeof(buf2);
	testbuf2->content = (uint8_t*)os_malloc(testbuf2->length*sizeof(uint8_t));
	os_memcpy(testbuf2->content, buf2, testbuf2->length);

	uint8_t buf3[]="dsagah123456789";
	DMESSAGE_POINTER *testbuf3 = (DMESSAGE_POINTER*)os_malloc(sizeof(DMESSAGE_POINTER));
	testbuf3->length = sizeof(buf3);
	testbuf3->content = (uint8_t*)os_malloc(testbuf3->length*sizeof(uint8_t));
	os_memcpy(testbuf3->content, buf3, testbuf3->length);
	inser_queuelist_tail(testbuf1);
	inser_queuelist_tail(testbuf2);
	inser_queuelist_tail(testbuf3);

	DMESSAGE_POINTER* temp;
	temp = get_queuelist_head_data();
	QUEUELIST_DEBUG("buf1 %s\n", temp->content, temp->length);
	delete_queuelist_head();
	temp = get_queuelist_head_data();
	QUEUELIST_DEBUG("buf2 %s\n", temp->content, temp->length);
	delete_queuelist_head();
	temp = get_queuelist_head_data();
	QUEUELIST_DEBUG("buf3 %s\n", temp->content, temp->length);
	delete_queuelist_head();
	delete_queuelist_head();

	inser_queuelist_tail(testbuf2);
	inser_queuelist_tail(testbuf1);
	temp = get_queuelist_head_data();
	QUEUELIST_DEBUG("buf2 %s\n", temp->content, temp->length);
	delete_queuelist_head();
	temp = get_queuelist_head_data();
	QUEUELIST_DEBUG("buf1 %s\n", temp->content, temp->length);
	//free data
}

