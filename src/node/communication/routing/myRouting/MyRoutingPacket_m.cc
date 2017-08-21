//
// Generated file, do not edit! Created by nedtool 4.6 from src/node/communication/routing/myRouting/MyRoutingPacket.msg.
//

// Disable warnings about unused variables, empty switch stmts, etc:
#ifdef _MSC_VER
#  pragma warning(disable:4101)
#  pragma warning(disable:4065)
#endif

#include <iostream>
#include <sstream>
#include "MyRoutingPacket_m.h"

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
    cEnum *e = cEnum::find("MyRoutingPacketDef");
    if (!e) enums.getInstance()->add(e = new cEnum("MyRoutingPacketDef"));
    e->insert(MPRINGS_DATA_PACKET, "MPRINGS_DATA_PACKET");
    e->insert(MPRINGS_TOPOLOGY_SETUP_PACKET, "MPRINGS_TOPOLOGY_SETUP_PACKET");
);

Register_Class(MyRoutingPacket);

MyRoutingPacket::MyRoutingPacket(const char *name, int kind) : ::RoutingPacket(name,kind)
{
    this->MyRoutingPacketKind_var = 0;
    this->sinkID_var = 0;
    this->senderLevel_var = 0;
}

MyRoutingPacket::MyRoutingPacket(const MyRoutingPacket& other) : ::RoutingPacket(other)
{
    copy(other);
}

MyRoutingPacket::~MyRoutingPacket()
{
}

MyRoutingPacket& MyRoutingPacket::operator=(const MyRoutingPacket& other)
{
    if (this==&other) return *this;
    ::RoutingPacket::operator=(other);
    copy(other);
    return *this;
}

void MyRoutingPacket::copy(const MyRoutingPacket& other)
{
    this->MyRoutingPacketKind_var = other.MyRoutingPacketKind_var;
    this->sinkID_var = other.sinkID_var;
    this->senderLevel_var = other.senderLevel_var;
}

void MyRoutingPacket::parsimPack(cCommBuffer *b)
{
    ::RoutingPacket::parsimPack(b);
    doPacking(b,this->MyRoutingPacketKind_var);
    doPacking(b,this->sinkID_var);
    doPacking(b,this->senderLevel_var);
}

void MyRoutingPacket::parsimUnpack(cCommBuffer *b)
{
    ::RoutingPacket::parsimUnpack(b);
    doUnpacking(b,this->MyRoutingPacketKind_var);
    doUnpacking(b,this->sinkID_var);
    doUnpacking(b,this->senderLevel_var);
}

int MyRoutingPacket::getMyRoutingPacketKind() const
{
    return MyRoutingPacketKind_var;
}

void MyRoutingPacket::setMyRoutingPacketKind(int MyRoutingPacketKind)
{
    this->MyRoutingPacketKind_var = MyRoutingPacketKind;
}

int MyRoutingPacket::getSinkID() const
{
    return sinkID_var;
}

void MyRoutingPacket::setSinkID(int sinkID)
{
    this->sinkID_var = sinkID;
}

int MyRoutingPacket::getSenderLevel() const
{
    return senderLevel_var;
}

void MyRoutingPacket::setSenderLevel(int senderLevel)
{
    this->senderLevel_var = senderLevel;
}

class MyRoutingPacketDescriptor : public cClassDescriptor
{
  public:
    MyRoutingPacketDescriptor();
    virtual ~MyRoutingPacketDescriptor();

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

Register_ClassDescriptor(MyRoutingPacketDescriptor);

MyRoutingPacketDescriptor::MyRoutingPacketDescriptor() : cClassDescriptor("MyRoutingPacket", "RoutingPacket")
{
}

MyRoutingPacketDescriptor::~MyRoutingPacketDescriptor()
{
}

bool MyRoutingPacketDescriptor::doesSupport(cObject *obj) const
{
    return dynamic_cast<MyRoutingPacket *>(obj)!=NULL;
}

const char *MyRoutingPacketDescriptor::getProperty(const char *propertyname) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? basedesc->getProperty(propertyname) : NULL;
}

int MyRoutingPacketDescriptor::getFieldCount(void *object) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    return basedesc ? 3+basedesc->getFieldCount(object) : 3;
}

unsigned int MyRoutingPacketDescriptor::getFieldTypeFlags(void *object, int field) const
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

const char *MyRoutingPacketDescriptor::getFieldName(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldName(object, field);
        field -= basedesc->getFieldCount(object);
    }
    static const char *fieldNames[] = {
        "MyRoutingPacketKind",
        "sinkID",
        "senderLevel",
    };
    return (field>=0 && field<3) ? fieldNames[field] : NULL;
}

int MyRoutingPacketDescriptor::findField(void *object, const char *fieldName) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    int base = basedesc ? basedesc->getFieldCount(object) : 0;
    if (fieldName[0]=='M' && strcmp(fieldName, "MyRoutingPacketKind")==0) return base+0;
    if (fieldName[0]=='s' && strcmp(fieldName, "sinkID")==0) return base+1;
    if (fieldName[0]=='s' && strcmp(fieldName, "senderLevel")==0) return base+2;
    return basedesc ? basedesc->findField(object, fieldName) : -1;
}

const char *MyRoutingPacketDescriptor::getFieldTypeString(void *object, int field) const
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

const char *MyRoutingPacketDescriptor::getFieldProperty(void *object, int field, const char *propertyname) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldProperty(object, field, propertyname);
        field -= basedesc->getFieldCount(object);
    }
    switch (field) {
        case 0:
            if (!strcmp(propertyname,"enum")) return "MyRoutingPacketDef";
            return NULL;
        default: return NULL;
    }
}

int MyRoutingPacketDescriptor::getArraySize(void *object, int field) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getArraySize(object, field);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingPacket *pp = (MyRoutingPacket *)object; (void)pp;
    switch (field) {
        default: return 0;
    }
}

std::string MyRoutingPacketDescriptor::getFieldAsString(void *object, int field, int i) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldAsString(object,field,i);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingPacket *pp = (MyRoutingPacket *)object; (void)pp;
    switch (field) {
        case 0: return long2string(pp->getMyRoutingPacketKind());
        case 1: return long2string(pp->getSinkID());
        case 2: return long2string(pp->getSenderLevel());
        default: return "";
    }
}

bool MyRoutingPacketDescriptor::setFieldAsString(void *object, int field, int i, const char *value) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->setFieldAsString(object,field,i,value);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingPacket *pp = (MyRoutingPacket *)object; (void)pp;
    switch (field) {
        case 0: pp->setMyRoutingPacketKind(string2long(value)); return true;
        case 1: pp->setSinkID(string2long(value)); return true;
        case 2: pp->setSenderLevel(string2long(value)); return true;
        default: return false;
    }
}

const char *MyRoutingPacketDescriptor::getFieldStructName(void *object, int field) const
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

void *MyRoutingPacketDescriptor::getFieldStructPointer(void *object, int field, int i) const
{
    cClassDescriptor *basedesc = getBaseClassDescriptor();
    if (basedesc) {
        if (field < basedesc->getFieldCount(object))
            return basedesc->getFieldStructPointer(object, field, i);
        field -= basedesc->getFieldCount(object);
    }
    MyRoutingPacket *pp = (MyRoutingPacket *)object; (void)pp;
    switch (field) {
        default: return NULL;
    }
}


