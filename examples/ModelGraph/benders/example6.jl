using JuMP
using GLPKMathProgInterface
using Plasmo

##Place MP and SP into ModelGraph
mp = Model(solver = GLPKSolverLP())
sp = Model(solver = GLPKSolverLP())

@variable(mp,y>=1)
@objective(mp,Min,2y)

@variable(sp,x[1:2]>=0)
@variable(sp,y>=0)
@constraint(sp,x[1:2].<=1)
@constraint(sp,x[1]+2x[2]+y>=5)
@objective(sp,Min,2x[1]+3x[2])

## Plasmo Graph
g = ModelTree()
setsolver(g, BendersSolver(lp_solver = GLPKSolverLP()))
n1 = add_node!(g)
setmodel(n1,mp)
n2 = add_node!(g,level = 2)
setmodel(n2,sp)

## Linking constraints between MP and SP
@linkconstraint(g, n1[:y] == n2[:y])

solve(g,max_iterations = 20)
