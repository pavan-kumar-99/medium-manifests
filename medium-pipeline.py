import kfp
from kfp import dsl
import kfp.components as comp

# Creating a component
@comp.create_component_from_func
def process_data_op():
    print("Processing Data")


@comp.create_component_from_func
def train_op():
    print("Training ML Model")

# Creating the pipeline
@dsl.pipeline(
    name='sequential-pipeline',
    description='A pipeline for Medium Followers.'
)
def sequential_pipeline():
    """A pipeline that mocks an ML Model"""

    process_task = process_data_op()
    train_task = train_op()
    train_task.after(process_task)

if __name__ == '__main__':
    kfp.compiler.Compiler().compile(sequential_pipeline, __file__ + '.yaml')
