
import graphene 

class Query(graphene.ObjectType):
    is_staff = graphene.Boolean()




schema = graphene.Schema(query=Query)




