//
// Generated file, do not edit! Created by nedtool 4.6 from src/node/communication/routing/myRouting/MyRoutingControl.msg.
//

// Disable warnings about unused variables, empty switch stmts, etc:
#ifdef _MSC_VER
#  pragma warning(disable:4101)
#  pragma warning(disable:4065)
#endif

#include <iostream>
#include <sstream>
#include "MyRoutingControl_m.h"

USING_NAMESPACE


// Another default rule (prevents compiler from choosing base class' doPacking())
template<typename T>
void doPacking(cCommBuffer *, T& t) {
    throw cRuntimeError("Parsim error: no doPacking() function for type %s or its base class (check .msg and _m.cc/h files!)",opp_typename(typeid(t)));
}

template<typename T>
void doUnpacking(cCommBuffer *, T& t) {
    throw cRuntimeError("Parsim error: no doUnpacking() function for type %s or its base class (check .msg and _m.cc/h files!)",opp_typename(typeid(t)));
}




// Template rule for outputting std::vector<T> types
template<typename T, typename A>
inline std::ostream& operator<<(std::ostream& out, const std::vector<T,A>& vec)
{
    out.put('{');
    for(typename std::vector<T,A>::const_iterator it = vec.begin(); it != vec.end(); ++it)
    {
        if (it != vec.begin()) {
            out.put(','); out.put(' ');
        }
        out << *it;
    }
    out.put('}');
    
    char buf[32];
    sprintf(buf, " (size=%u)", (unsigned int)vec.size());
    out.write(buf, strlen(buf));
    return out;
}

// Template rule which fires if a struct or class doesn't have operator<<
template<typename T>
inline std::ostream& operator<<(std::ostream& out,const T&) {return out;}

EXECUTE_ON_STARTUP(
    cEnum *e = cEnum::find("MyRoutingControlDef");
    if (!e) enums.getInstance()->add(e = new cEnum("MyRoutingControlDef"));
    e->insert(MPRINGS_NOT_CONNECTED, "MPRINGS_NOT_CONNECTED");
    e->insert(MPRINGS_CONNECTED_TO_TREE, "MPRINGS_CONNECTED_TO_TREE");
    e->insert(MPRINGS_TREE_LEVEL_UPDATED, "MPRINGS_TREE_LEVEL_UPDATED");
);

Register_Class(MyRoutingControlMessage);

MyRoutingControlMessage::MyRoutingControlMessage(const char *name, int kind) : ::cMessage(name,kind)
{
    this->MyRoutingControlMessageKind_var = 0;
    this->sinkID_var = 0;
    this->level_var = 0;
}

MyRoutingControlMessage::MyRoutingControlMessage(const MyRoutingControlMessage& other) : ::cMessage(other)
{
    copy(other);
}

MyRoutingControlMessage::~MyRoutingControlMessage()
{
}

MyRoutingControlMessage& MyRoutingControlMessage::operator=(const MyRoutingControlMessage& other)
{
    if (this==&other) return *this;
    ::cMessage::operator=(other);
    copy(other);
    return *this;
}

void MyRoutingControlMessage::copy(const MyRoutingControlMessage& other)
{
    this->MyRoutingControlMessageKind_var = other.MyRoutingControlMessageKind_var;
    this->sinkID_var = other.sinkID_var;
    this->level_var = other.level_var;
}

void MyRoutingControlMessage::parsimPack(cCommBuffer *b)
{
    ::cMessage::parsimPack(b);
    doPacking(b,this->MyRoutingControlMessageKind_var);
    doPacking(b,this->sinkID_var);
    doPacking(b,this->level_var);
}

void MyRoutingControlMessage::parsimUnpack(cCommBuffer *b)
{
    ::cMessage::parsimUnpack(b);
    doUnpacking(b,this->MyRoutingControlMessageKind_var);
    doUnpacking(b,this->sinkID_var);
    doUnpacking(b,this->level_var);
}

int MyRoutingControlMessage::getMyRoutingControlMessageKind() const
{
    return MyRoutingControlMessageKind_var;
}

void MyRoutingControlMessage::setMyRoutingControlMessageKind(int MyRoutingControlMessageKind)
{
    this->MyRoutingControlMessageKind_var = MyRoutingControlMessageKind;
}

int MyRoutingControlMessage::getSinkID() const
{
    return sinkID_var;
}

void MyRoutingControlMessage::setSinkID(int sinkID)
{
    this->sinkID_var = sinkID;
}

int MyRoutingControlMessage::getLevel() const
{
    return level_var;
}

void MyRoutingControlMessage::setLevel(int level)
{
    this->level_var = level;
}

class MyRoutingControlMessageDescriptor : public cClassDescriptor
{
  public:
    MyRoutingControlMessageDescriptor();
    virtual ~MyRoutingControlMessageDescriptor();

    virtual bool doesSupport(cObject *obj) const;
    virtual const char *getProperty(const char *propertyname) const;
    virtual int getFieldCount(void *object) const;
    virtual const char *getFieldName(void *object, int field) const;
    virtual int findField(void *object, const char *fieldName) const;
    virtual unsigned int getFieldTypeFlags(void *object, int field) const;
    virtual const char *getFieldTypeString(void *object, int field) const;
    virtual const char *getFieldProperty(void *object, int field, const char *propertyname) const;
    virtual int getArraySize(void *object, int field) const;

    virtual std::string getFieldAsString(void *object, int field, int i) const;
    virtual bool setFieldAsString(void *object, int field, int i, const char *value) const;

    virtual const char *getFieldStructName(void *object, int field) const;
    virtual void *getFieldStructPointer(void *object, int field, int i) const;
};

Register_ClassDescriptor(MyRoutingControlMessageDescriptor);

MyRoutingControlMessageDescriptor::MyRoutingControlMessageDescriptor() : cClassDescriptor("MyRoutingControlMessage", "cMessage")
{
}

MyRoutingControlMessageDescriptor::~MyRoutingControlMessageDescriptor()
{
}

bool MyRoutingControlMessageDescriptor::doesSupport(cObject *obj) const
{
    return dynamic_cast<MyRoutingControlMessage *>(obj)!=NULL;
}

const char *MyRoutingControlMessageDescriptor::getProperty(const char *propertyname) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : NULL;
}

int MyRoutingControlMessageDescriptor::getFieldCount(void *object) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 3+basedesc->getFieldCount(object) : 3;
}

unsigned int MyRoutingControlMessageDescriptor::getFieldTypeFlags(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldTypeFlags(object, field);
        field -= basedesc->getFieldCount(object);
    }
    static unsigned int fieldTypeFlags[] = {
        FD_ISEDITABLE,
        FD_ISEDITABLE,
        FD_ISEDITABLE,
    };
    return (field>=0 && field<3) ? fieldTypeFlags[field] : 0;
}

const char *MyRoutingControlMessageDescriptor::getFieldName(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldName(object, field);
        field -= basedesc->getFieldCount(object);
    }
    static const char *fieldNames[] = {
        "MyRoutingControlMessageKind",
        "sinkID",
        "level",
    };
    return (field>=0 && field<3) ? fieldNames[field] : NULL;
}

int MyRoutingControlMessageDescriptor::findField(void *object, const char *fieldName) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount(object) : 0;
    if (fieldName[0]=='M' && strcmp(fieldName, "MyRoutingControlMessageKind")==0) return base+0;
    if (fieldName[0]=='s' && strcmp(fieldName, "sinkID")==0) return base+1;
    if (fieldName[0]=='l' && strcmp(fieldName, "level")==0) return base+2;
    return basedesc ? basedesc->findField(object, fieldName) : -1;
}

const char *MyRoutingControlMessageDescriptor::getFieldTypeString(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldTypeString(object, field);
        field -= basedesc->getFieldCount(object);
    }
    static const char *fieldTypeStrings[] = {
        "int",
        "int",
        "int",
    };
    return (field>=0 && field<3) ? fieldTypeStrings[field] : NULL;
}

const char *MyRoutingControlMessageDescriptor::getFieldProperty(void *object, int field, const char *propertyname) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldProperty(object, field, propertyname);
        field -= basedesc->getFieldCount(object);
    }
    switch (field) {
        case 0:
            if (!strcmp(propertyname,"enum")) return "MyRoutingControlDef";
            return NULL;
        default: return NULL;
    }
}

int MyRoutingControlMessageDescriptor::getArraySize(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getArraySize(object, field);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingControlMessage *pp = (MyRoutingControlMessage *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

std::string MyRoutingControlMessageDescriptor::getFieldAsString(void *object, int field, int i) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldAsString(object,field,i);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingControlMessage *pp = (MyRoutingControlMessage *)object; (void)pp;
    switch (field) {
        case 0: return long2string(pp->getMyRoutingControlMessageKind());
        case 1: return long2string(pp->getSinkID());
        case 2: return long2string(pp->getLevel());
        default: return "";
    }
}

bool MyRoutingControlMessageDescriptor::setFieldAsString(void *object, int field, int i, const char *value) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->setFieldAsString(object,field,i,value);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingControlMessage *pp = (MyRoutingControlMessage *)object; (void)pp;
    switch (field) {
        case 0: pp->setMyRoutingControlMessageKind(string2long(value)); return true;
        case 1: pp->setSinkID(string2long(value)); return true;
        case 2: pp->setLevel(string2long(value)); return true;
        default: return false;
    }
}

const char *MyRoutingControlMessageDescriptor::getFieldStructName(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldStructName(object, field);
        field -= basedesc->getFieldCount(object);
    }
    switch (field) {
        default: return NULL;
    };
}

void *MyRoutingControlMessageDescriptor::getFieldStructPointer(void *object, int field, int i) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldStructPointer(object, field, i);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingControlMessage *pp = (MyRoutingControlMessage *)object; (void)pp;
    switch (field) {
        default: return NULL;
    }
}


